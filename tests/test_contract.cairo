use snforge_std::{
    declare, ContractClassTrait, cheat_caller_address, start_cheat_caller_address,
    stop_cheat_caller_address, CheatSpan, spy_events, SpyOn, EventSpy, EventAssertions
};
use todoa::todo::Todo;
use todoa::todo::ITodoDispatcherTrait;
use todoa::todo::ITodoDispatcher;
use starknet::ContractAddress;
use core::traits::TryInto;


fn deploy_contract(name: ByteArray) -> ContractAddress {
    let admin_address: ContractAddress = 'admin'.try_into().unwrap();
    let contract = declare(name).unwrap();
    let (contract_address, _) = contract.deploy(@array![admin_address.into()]).unwrap();
    contract_address
}


#[test]
fn test_initial_owner() {
    let admin_address: ContractAddress = 'admin'.try_into().unwrap();
    let contract_address = deploy_contract("Todo");
    let dispatcher = ITodoDispatcher { contract_address };

    let initial_owner = dispatcher.get_owner();

    assert(initial_owner == admin_address, 'incorrect admin');
}

#[test]
fn test_for_adding_todo() {
    let contract_address = deploy_contract("Todo");
    let dispatcher = ITodoDispatcher { contract_address };
    let title = 'Wash';
    let description = 'I am washing today';

    let create_todo = dispatcher.create_todo(title, description);

    let new_title = dispatcher.get_specific_title(0);
    let new_description = dispatcher.get_specific_description(0);   

    let check_title: bool = new_title == 'Wash';
    let check_description: bool = new_description == 'I am washing today';
    
    assert(create_todo, 'Todo Creation Failed');
    assert(check_title, 'Wrong Title');
    assert(check_description, 'Wrong Description');

    
}

#[test]
fn test_for_update_todo_title() {
    let contract_address = deploy_contract("Todo");
    let dispatcher = ITodoDispatcher { contract_address };

   
    let title = 'Wash';
    let description = 'I am washing today';

    let create_todo = dispatcher.create_todo(title, description);

    let update_todo_title = dispatcher.update_todo_title('Cook', 1);

    assert(update_todo_title, 'Title did not update');


    assert(create_todo, 'Did not update Todo Title');
}

#[test]
fn test_for_update_todo_description() {
    let contract_address = deploy_contract("Todo");
    let dispatcher = ITodoDispatcher { contract_address };

    
    let title = 'Wash';
    let description = 'I am washing today';

    let create_todo = dispatcher.create_todo(title, description);

    let update_todo_description = dispatcher.update_todo_description('Cook yam and egg sauce', 1);

    assert(update_todo_description, 'Description did not update');


    assert(create_todo, 'Did not Update Todo Description');
}
