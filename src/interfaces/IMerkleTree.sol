// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IMerkleTree {

    struct Leaves {
        address[] leaves;
    }

    struct Proofs {
        bytes32[][] proofs;
    }

    //Getter function for reading from .txt file, storing the result in a .json file and returning directly to user.
    function getLeaves(string memory filename) external returns (Leaves memory);
    function getMerkleRoot(string memory filename) external returns (bytes32);
    function getMerkleProofs(string memory filename) external returns (Proofs memory);
    function getMerkleTree(string memory filename) external returns (Leaves memory, Proofs memory, bytes32);
}