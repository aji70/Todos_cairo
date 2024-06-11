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

    let new_title = dispatcher.get_specific_title(1);
    let new_description = dispatcher.get_specific_description(1);   

    let check_description: bool = new_description == 'I am washing today';
    let check_title: bool = new_title == 'Wash';

    assert(create_todo, 'Todo Creation Failed');
    assert(check_title, 'Wrong Title');
    assert(check_description, 'Wrong Description');
    
    let title1 = 'Cook';
    let description1 = 'I am Cooking today';

    let create_todo1 = dispatcher.create_todo(title1, description1);

    let new_title1 = dispatcher.get_specific_title(2);
    let new_description1 = dispatcher.get_specific_description(2);   

    let check_description1: bool = new_description1 == 'I am Cooking today';
    let check_title1: bool = new_title1 == 'Cook';


    assert(create_todo1, 'Todo Creation Failed');
    assert(check_title1, 'Wrong Title');
    assert(check_description1, 'Wrong Description');
    
    

    
}

#[test]
fn test_for_update_todo_title() {
    let contract_address = deploy_contract("Todo");
    let dispatcher = ITodoDispatcher { contract_address };

   
    let title = 'Wash';
    let description = 'I am washing today';

    let create_todo = dispatcher.create_todo(title, description);


    dispatcher.update_todo_title('Cook', 1);

    let new_description = dispatcher.get_specific_title(1);   

    let check: bool = new_description == 'Cook';

    assert(check, 'Title did not update');

    assert(create_todo, 'Todo Creation Failed');
}

#[test]
fn test_for_update_todo_description() {
    let contract_address = deploy_contract("Todo");
    let dispatcher = ITodoDispatcher { contract_address };

   
    let title = 'Wash';
    let description = 'I am washing today';

    let create_todo = dispatcher.create_todo(title, description);


    dispatcher.update_todo_description('I am Cooking rice', 1);

    let new_description = dispatcher.get_specific_description(1);   

    let check: bool = new_description == 'I am Cooking rice';

    assert(check, 'Description did not update');

    assert(create_todo, 'Todo Creation Failed');
    


}
