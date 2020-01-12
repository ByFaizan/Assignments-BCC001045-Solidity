pragma solidity ^0.5.0;

interface IBank {
    
        // interface 
        function deposit() external payable;
        function withdraw(uint _withdrawalAmunt) external;
        function checkMyBalance() external view returns(uint);
    
}


contract FaizanLtdBank is IBank {
    
            // for addresses with there respective balances
            mapping ( address => uint ) AcountBalance;
            
            address payable accountOwner; //simple acount type
        
            
            
            // events to be used for logging changes
            event depositCompleted(address, uint, string);
            event withdrawalCompleted(address, uint, string);
            event newAccountCreated(address, string);
            event accountClosed(address, string);
        

    // initiating account with charges
    constructor() payable public {
        
        require(msg.value >= 2 ether, "Please Pay The Initial Charges For An Account (2 Ether)");
        accountOwner = msg.sender;
        
        emit newAccountCreated(accountOwner, "Bank Created Successfully");
    
    }
    
    
    // to give special permissions for account owner
    modifier onlyAccountOwner() {
        
        require(msg.sender == accountOwner, "Access Denied");
        _;
        
    }

    // to close off an account
    function closeAccount() onlyAccountOwner public payable {
        
        emit accountClosed(accountOwner, "Account Closed");
        selfdestruct(accountOwner);
        
    }
    
    // to deposit ether in the contract(Faizan Ltd. Bank :D)
    function deposit() external payable {
        
        require(msg.value > 0);
        AcountBalance[msg.sender] += msg.value;
        
        emit depositCompleted(msg.sender, msg.value, "Deposit Complete");
    
    }
    
    // to withdraw ethers 
    function withdraw(uint _withdrawalAmunt) external onlyAccountOwner {
        
        uint amount = _withdrawalAmunt * 1000000000000000000;
        
        require(AcountBalance[msg.sender] >= amount, "Sorry, Low On Balance");
        AcountBalance[msg.sender] -= amount;
        address(msg.sender).transfer(amount);
    
        emit withdrawalCompleted(msg.sender, amount, "Withdrawal Complete");
        
    }
    
    // to check balance of an account
    function checkMyBalance() external view returns(uint) {
        
        return AcountBalance[msg.sender];
        
    }
    
    // to check the total ethers accumulated
    function totalEtherInBank() external view returns(uint) {
        
        return address(this).balance;
        
    }
    
}
