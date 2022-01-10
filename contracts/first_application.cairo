%lang starknet
%builtins pedersen range_check

from starkware.cairo.common.cairo_builtins import HashBuiltin

@storage_var
func balance() -> (res : felt):
end

@view
func get{
     syscall_ptr: felt*,
     pedersen_ptr: HashBuiltin*,
     range_check_ptr
}() -> (
    value : felt
    ):
    let (value) = balance.read()
    return (value)
end

@external
func increase{
     syscall_ptr: felt*,
     pedersen_ptr: HashBuiltin*,
     range_check_ptr
     }():
     let (res) = balance.read()
     balance.write(res + 1)
     return ()
end
