pragma solidity ^0.4.8;

contract Referendum {
    struct Result {
        uint yes;
        uint no;
        uint number;
    }

    struct Vote {
        bool hasVoted;
        bool answer;
    }

    mapping (address => Vote) votes;
    Result result;
    string public subject;
    uint public End ;
    address owner;
    
     function Set_End(uint end) public isowner(){
       End=block.number+end;
   }

     modifier isowner(){//call for identification
       if(msg.sender!=owner){
           throw;
       }
       _;
    }
       


    function Referendum(string _subject,uint _End) {
        subject = _subject;
        owner = msg.sender;
        result = Result(0, 0, 0);
        End=block.number+_End;
    }

    event HasVoted(address voter);

    function vote(bool answer) private returns (bool) {//allow to vote
        address voter = msg.sender;
        if(votes[voter].hasVoted) return false;//impossible to vote if already voted
        else {
            if(block.number>End) return false;//impossible after date exprimed in blocks
            if(answer) result.yes++;
            else result.no++;
            result.number++;
            votes[voter].answer = answer;
            votes[voter].hasVoted = true;
            HasVoted(voter);//block the possibility to alter your answer
            return true;
        }
    }

    function sayYes() returns(bool) {
        return vote(true);
    }

    function sayNo() returns(bool) {
        return vote(false);
    }

    function getResult() public constant returns(uint, uint, uint) {
        return (result.yes, result.no, result.number);
    }
    
    

    function Cloture() {//aka fonction kill
        if(owner == msg.sender) {
            getResult();
            suicide(owner);
        }
    }
}
