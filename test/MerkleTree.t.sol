pragma solidity ^0.8.13;

import "fixtures/MerkleTreeFixture.sol";

contract MerkleTreeExtensionTest is MerkleTreeFixture {

    function test_CanGetLeavesCorrectly() public {
        Leaves memory leavesResult = getLeaves(INPUT_FILE);

        assertEq(leavesResult.leaves.length, EXPECTED_LENGTH);

        for (uint i; i < leavesResult.leaves.length;) {
            assertEq(leavesResult.leaves[i], EXPECTED_LEAVES[i]);

            unchecked {++i;}
        }
    }

    function test_CanGetMerkleRootCorrectly() public {
        bytes32 result = getMerkleRoot(INPUT_FILE);

        assertEq(result, EXPECTED_ROOT);
    }

    function test_CanGetMerkleProofsCorrectly() public {
        Proofs memory proofsResult = getMerkleProofs(INPUT_FILE);

        for (uint i; i < proofsResult.proofsLength.length - 16;) {
            assertEq(proofsResult.proofsLength[i], EXPECTED_PROOFS_LENGTH[i]);

            for (uint j; j < proofsResult.proofs[i].length;) {
                assertEq(proofsResult.proofs[i][j], EXPECTED_PROOFS[i][j]);

                unchecked {++j;}
            }

            unchecked {++i;}
        }

        for (uint k = proofsResult.proofsLength.length - 16; k < proofsResult.proofsLength.length;) {
            assertEq(proofsResult.proofsLength[k], EXPECTED_PROOFS_LENGTH[k]);

            for (uint m; m < proofsResult.proofs[k].length;) {
                assertEq(proofsResult.proofs[k][m], EXPECTED_PROOFS_2[k - 1984][m]);

                unchecked {++m;}
            }

            unchecked {++k;}
        }
    }

    function test_CanGetMerkleTreeCorrectly() public {
        (Leaves memory leavesResult, Proofs memory proofsResult, bytes32 root) = getMerkleTree(INPUT_FILE);

        // Check Length and Root
        assertEq(root, EXPECTED_ROOT);
        assertEq(leavesResult.leaves.length, EXPECTED_LENGTH);

        // Check leaves
        for (uint i; i < leavesResult.leaves.length;) {
            assertEq(leavesResult.leaves[i], EXPECTED_LEAVES[i]);

            unchecked {++i;}
        }

        // Check ProofsLength and Proofs
        for (uint h; h < proofsResult.proofsLength.length - 16;) {
            assertEq(proofsResult.proofsLength[h], EXPECTED_PROOFS_LENGTH[h]);

            for (uint j; j < proofsResult.proofs[h].length;) {
                assertEq(proofsResult.proofs[h][j], EXPECTED_PROOFS[h][j]);

                unchecked {++j;}
            }

            unchecked {++h;}
        }

        for (uint k = proofsResult.proofsLength.length - 16; k < proofsResult.proofsLength.length;) {
            assertEq(proofsResult.proofsLength[k], EXPECTED_PROOFS_LENGTH[k]);

            for (uint m; m < proofsResult.proofs[k].length;) {
                assertEq(proofsResult.proofs[k][m], EXPECTED_PROOFS_2[k - 1984][m]);

                unchecked {++m;}
            }

            unchecked {++k;}
        }
    }
}