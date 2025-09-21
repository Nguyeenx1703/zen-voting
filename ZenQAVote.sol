// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ZenQAVote {
    struct Question {
        string questionText;
        string[] options;
        mapping(string => uint256) votes;
    }

    mapping(uint256 => Question) public questions;
    uint256 public questionCount;

    function addQuestion(string memory _questionText, string[] memory _options) public {
        require(_options.length == 3, "Must provide exactly 3 options");
        Question storage newQuestion = questions[questionCount];
        newQuestion.questionText = _questionText;
        newQuestion.options = _options;
        questionCount++;
    }

    function vote(uint256 _questionId, string memory _option) public {
        Question storage question = questions[_questionId];
        bool validOption = false;
        for (uint i = 0; i < question.options.length; i++) {
            if (keccak256(abi.encodePacked(question.options[i])) == keccak256(abi.encodePacked(_option))) {
                validOption = true;
                break;
            }
        }
        require(validOption, "Invalid option");
        require(_questionId < questionCount, "Invalid question ID");
        question.votes[_option]++;
    }

    function getVotes(uint256 _questionId, string memory _option) public view returns (uint256) {
        return questions[_questionId].votes[_option];
    }

    function getQuestion(uint256 _questionId) public view returns (string memory, string[] memory) {
        return (questions[_questionId].questionText, questions[_questionId].options);
    }
}
