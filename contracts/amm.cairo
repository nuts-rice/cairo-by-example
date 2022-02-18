%builtins output pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.dict import dict_new, dict_read, dict_squash, dict_update, dict_write
from starkware.cairo.common.dict_accesss import DictAccess
from starkware.cairo.common.hash import hash2
from starkware.cairo.common.math import assert_nn_le, unsigned_div_rem
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.small_merkle_tree import small_merkle_tree

struct Account:
       member public_key: felt
       member token_a_balance: felt
       memeber token_b_balance: felt
end

const MAX_BALANCE = 2 ** 64 - 1

struct AmmState:
       member account_dict_start: DictAccess*,
       memeber account_dict_end: DictAccess*,
       member token_a_balance: felt,
       member token_b_balance: felt
end

func modify_account{range_check_ptr}(state: AmmState, account_id, diff_a, diff_b) -> (
     state : AmmState, key):
     alloc_locals

     #define refrenece to state.account_dict_end
     #we can use as implicit argument to the dict function
     let account_dict_end = state.account_dict_end

     let (local old_account : Account*) = dict_read{dict_ptr=account_dict_end}(key=account_id)

     tempvar new_token_a_balance = (
             old_account.token_a_balance + diff_a)
     tempvar new_token_b_balance = (
             old_account.token_b_balance + diff_b)

     #verify new balances are positive
     assert_nn_le(new_token_a_balance, MAX_BALANCE)
     assert_nn_le(new_token_b_balance, MAX_BALANCE)

     #new account instance
     local new_account : Account
     assert new_account.public_key = old_account.public_key
     assert new_account.token_a_balance = new_token_a_balance
     assert new_account.token_b_balance = new_token_b_balance

     #perform the account update
     let (__fp__, _) = get_fp_and_pc()
     dict_write{dict_ptr=account_dict_end}(key=account_id, new_value=cast(&new_account, felt))

     local new_state: AmmState
     assert new_state.account_dict_start = (
            state.account_dict_start_start)
     assert new_state.account_dict_end = account_dict_end
     assert new_state.token_a_balance = state.token_a_balance
     assert new_state.token_b_balance = state.token_b
