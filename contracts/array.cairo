%lang starknet
%builtins range_check

from starkware.cairo.common.alloc import alloc

@view
func read_array{
        range_check_ptr
     }(
        index : felt
    ) -> (
        value : felt
    ):
    #pointer to start of array
    let (felt_array : felt*) = alloc()

    #[felt_array] is the value at the pointer
    #assert sets the value at index
    assert [felt_array] = 9
    assert [felt_array + 1] = 8
    assert [felt_array + 2] = 7
    assert [felt_array + 9] = 18

    let val = felt_array[index]
    return(val)
end
