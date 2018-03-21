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
    address owner;

    function Referendum(string _subject) {
        subject = _subject;
        owner = msg.sender;
        result = Result(0, 0, 0);
    }

    event HasVoted(address voter);

    function vote(bool answer) private returns (bool) {
        address voter = msg.sender;
        if(votes[voter].hasVoted) return false;
        else {
            if(answer) result.yes++;
            else result.no++;
            result.number++;
            votes[voter].answer = answer;
            votes[voter].hasVoted = true;
            HasVoted(voter);
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

    function kill() {
        if(owner == msg.sender) {
            suicide(owner);
        }
    }
}
