import sys
import json
import os
from functools import reduce
from utils.merkletools import MerkleTools

path = os.path.realpath("lib/threesigma-contracts/src/extensions/merkle_tree_output/")
class FFIProvider():
    

    def output_int(self, integer):
        sys.stdout.write(str(hex(integer)[2:]).zfill(64))

    def output_string(self, string):
        sys.stdout.write(string)

    def output_addresses(self, filename):
        print()
        if os.path.exists(path + "/leaves.json"):
            os.remove(path + "/leaves.json")

        addresses = []
        with open(filename, "r") as f:
            lines = f.readlines()
            for line in lines:
                addresses.append('0x' + line[:-1])
                # output_dict = dict(list(output_dict.items()) + list({key: value}.items()))

        output_dict = {'addresses': addresses}
        
        json_output = json.dumps(output_dict, indent=4)

        with open(path + "/leaves.json", "w+") as output_file:
            output_file.write(json_output)
    
    def output_int_array(self, filename):
        integers = [] 
        with open(filename, "r") as f:
            for line in f.readlines():
                integers += [int(line, 16)] 
        result = reduce(lambda x, y :  str(x) + str(y) , integers)
        
        sys.stdout.write(result)
    
    def output_string_array(self, filename):
        strings = []
        with open(filename, "r") as f:
            for line in f.readlines():
                strings += [line[:-1]] 

        sys.stdout.write("".join(strings))
    
    def output_merkle_proofs(self, filename):
        if os.path.exists(path + "/proofs.json"):
            os.remove(path + "/proofs.json")

        mt = MerkleTools()

        with open(filename, "r") as f:
            n_leafs = len(f.readlines())
        
        mt.add_leaf([str(i).encode() for i in range(int(n_leafs))], True)
        mt.make_tree()

        lengths = [len(mt.get_proof(i)) for i in range(int(n_leafs))]

        output_dict = {'lengths': lengths}

        all_proofs = []

        for i in range(int(n_leafs)):
            this_proof=[]

            proof_dicts=mt.get_proof(i)
            for dict in proof_dicts:
                #Builds a list containing the proofs of 1 address
                val = list(dict.values())[0]
                this_proof.append(val)
            #Appends that list to the list global proofs

            all_proofs.append(this_proof)
        
        output_dict['proofs'] = all_proofs

        json_output = json.dumps(output_dict, indent = 4)

        with open(path + '/proofs.json', 'w') as output_file:
            output_file.write(json_output)

    def output_merkle_root(self,filename):
        mt = MerkleTools()

        with open(filename, "r") as f:
            n_leafs = len(f.readlines())
        
        mt.add_leaf([str(i).encode() for i in range(int(n_leafs))], True)
        mt.make_tree()

        root='0x' + str(mt.get_merkle_root())

        sys.stdout.write(root)

    def output_merkle_tree(self, filename):
        if os.path.exists(path + "/merkle_tree.json"):
            os.remove(path + "/merkle_tree.json")

        #Build the Merkle Tree
        mt = MerkleTools()

        with open(filename, "r") as f:
            lines = f.readlines()

        mt.add_leaf([str(i).encode() for i in range(int(len(lines)))], True)
        mt.make_tree()

        leaves = []
        all_proofs = [] 
        lengths = []

        # Populate leaves list
        for line in lines:
            leaves.append('0x' + line[:-1])
        
        # Populate proofs and proofs lengths list
        for i in range(len(lines)):
            this_proof=[]

            proof_dicts=mt.get_proof(i)
            lengths.append(len(proof_dicts))
            for dict in proof_dicts:
                #Builds a list containing the proofs of 1 address
                val = list(dict.values())[0]
                this_proof.append(val)
            #Appends that list to the list global proofs

            all_proofs.append(this_proof)

        output_dict = {'a_root': '0x' + str(mt.get_merkle_root())}
        output_dict['b_leaves'] = leaves
        output_dict['c_proofs_length'] = lengths
        output_dict['d_proofs'] = all_proofs

        json_output = json.dumps(output_dict, indent = 4)

        with open(path + '/merkle_tree.json', 'w') as output_file:
            output_file.write(json_output)

if __name__ == "__main__":

    func_name = sys.argv[1]
    arg2 = sys.argv[2]

    provider = FFIProvider()
    func = getattr(provider, func_name)
    func(arg2)
