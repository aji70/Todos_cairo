use starknet::ContractAddress;

#[starknet::interface]
pub trait ITodo<T> {
    fn create_todo(ref self: T, title: felt252, description: felt252) -> bool;
    fn toggle_completed(ref self: T,id: u8) -> bool;
    fn update_todo_title(ref self: T, title: felt252,id: u8) -> bool;
    fn update_todo_description(ref self: T, description: felt252,id: u8) -> bool;
    fn get_specific_todos(self: @T, id: u8) -> Todo::Todos;
    fn get_specific_title(self: @T, id: u8) -> felt252;
    fn get_specific_description(self: @T, id: u8) -> felt252;
    fn get_owner(self: @T) -> ContractAddress;
    
}

#[starknet::contract]
pub mod Todo {
    use core::starknet::event::EventEmitter;
    use super::ContractAddress;
    use starknet::get_caller_address;

    #[storage]
    struct Storage {
        todos: LegacyMap<u8, Todos>,
        todo_count: u8,
        owner: ContractAddress,
        // todo_array: Vec<Todos>,
    }

    #[derive(Drop, Serde, starknet::Store)]
    pub struct Todos {
        id: u8,
        title: felt252,
        description: felt252,
        is_done: bool
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_owner: ContractAddress) {
        self.owner.write(initial_owner)
    }

    #[abi(embed_v0)]
    impl TodoImpl of super::ITodo<ContractState> {
        // create todo
        fn create_todo(ref self: ContractState, title: felt252, description: felt252) -> bool {

            let  id = self.todo_count.read() + 1;

            let mut new_todo = Todos { id: id, title: title, description: description, is_done: false };

            self.todos.write(id, new_todo);

            self.todo_count.write(id);

            true
        }

        fn update_todo_title(ref self: ContractState, title: felt252,id: u8) -> bool {
            let mut todo = self.todos.read(id);
            todo.title = title;            
            self.todos.write(id, todo);
            true
        }

        fn update_todo_description(ref self: ContractState, description: felt252,id: u8) -> bool {
            let mut todo = self.todos.read(id);
             todo.description = description;   
             self.todos.write(id, todo);         
            true
        }

        fn get_specific_todos(self: @ContractState, id: u8) -> Todos {
            let todo = self.todos.read(id);
            todo
        }

       

        fn toggle_completed(ref self: ContractState,id: u8) -> bool{
            let mut todo = self.todos.read(id);
            todo.is_done = !todo.is_done;
            true

        }

        fn get_specific_title(self: @ContractState, id: u8) -> felt252 {
            let todo = self.todos.read(id);
            todo.title
        }

        fn get_specific_description(self: @ContractState, id: u8) -> felt252 {
            let todo = self.todos.read(id);
            todo.description
        }
        //get owner
        fn get_owner(self: @ContractState) -> ContractAddress {
            self.owner.read()
        }


    }
}