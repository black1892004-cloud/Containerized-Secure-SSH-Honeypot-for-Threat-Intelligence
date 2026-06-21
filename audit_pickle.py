import pickle

PICKLE_PATH = '/home/osboxes/shared-folder/HoneypotProject/honypot/cowrie/cowrie_data/etc/fs.pickle'

with open(PICKLE_PATH, 'rb') as f:
    data = pickle.load(f)

def check_for_oracle(contents, path=""):
    for item in contents:
        full_path = f"{path}/{item[0]}"
        if "oracle" in item[0]:
            print(f"[FOUND] {full_path}")
        if item[1] == 1: # Directory
            check_for_oracle(item[7], full_path)

print(f"Checking pickle: {PICKLE_PATH}")
check_for_oracle(data[7])
print("Audit complete.")

