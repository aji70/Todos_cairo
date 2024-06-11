use starknet::ContractAddress;

#[starknet::interface]
pub trait ITodo<T> {
    fn create_todo(ref self: T, title: felt252, description: felt252) -> bool;
    fn toggle_completed(ref self: T,id: u8) -> bool;
    fn delete_todo(ref self: T, id: u8) -> bool;
    fn update_todo_title(ref self: T, description: felt252,id: u8) -> bool;
    fn update_todo_description(ref self: T, description: felt252,id: u8) -> bool;
    fn get_all_todos(self: @T, index: u8) -> u32;
    fn get_specific_todos(self: @T, index: u8) -> u32;
    
}