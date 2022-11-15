// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/StdJson.sol";
import "../interfaces/IMerkleTree.sol";

contract MerkleTreeHelper is Test, IMerkleTree {

    using stdJson for string;

    function getLeaves(string memory filename) public returns (Leaves memory) {

        _executeScript("output_addresses", filename);

        string memory json = vm.readFile("merkle_tree_output/leaves.json");
        bytes memory rawAddresses = vm.parseJson(json);
        Leaves memory leaves = abi.decode(rawAddresses, (Leaves));

        return leaves;
    }

    function getMerkleRoot(string memory filename) public returns (bytes32) {

        string[] memory inputs = new string[](4);
        inputs[0] = "python3";
        inputs[1] = "lib/threesigma-contracts/src/scripts/MerkleTreeProvider.py";
        inputs[2] = "output_merkle_root";
        inputs[3] = filename;

        bytes memory res = vm.ffi(inputs);
        bytes32 root  = abi.decode(res, (bytes32));

        return root;
    }

    function getMerkleProofs(string memory filename) public returns (Proofs memory) {
        
        _executeScript("output_merkle_proofs", filename);

        string memory json = vm.readFile("merkle_tree_output/proofs.json");
        bytes memory rawProofs = vm.parseJson(json);
        Proofs memory proofs = abi.decode(rawProofs, (Proofs));

        return proofs;
    }

    function getMerkleTree(string memory filename) public returns (Leaves memory, Proofs memory, bytes32) {

        // This function does output the entire Merkle Tree's info to a json file
        // we don't translate it into a struct type variable however as it would overload memory
        _executeScript("output_merkle_tree", filename);

        Leaves memory leaves = getLeaves(filename);
        Proofs memory proofs = getMerkleProofs(filename);
        bytes32 root = getMerkleRoot(filename);

        return (leaves, proofs, root);
    }

    function _executeScript(string memory funcName, string memory filename) internal {
        string[] memory inputs = new string[](4);
        // change this to foundry cheatcodes not ffi with a python script
        inputs[0] = "python3";
        inputs[1] = "lib/threesigma-contracts/src/scripts/MerkleTreeProvider.py";
        inputs[2] = funcName;
        inputs[3] = filename;

        vm.ffi(inputs);
    }
}