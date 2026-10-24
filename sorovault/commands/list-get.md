# `list` and `get`

SoroVault keeps a searchable, versioned view of registered Soroban contract interfaces. These two read commands inspect that local registry; they do not fetch the network.

## `sorovault list`

```console
sorovault list [flags]
```

Lists registered contracts. The human-readable table contains:

| Column | Meaning |
| --- | --- |
| `CONTRACT ID` | The Soroban contract address. |
| `NETWORK` | The network stored with the contract. |
| `WASM HASH` | The current interface version's hash, truncated to 12 characters. |
| `LAST REFRESHED` | The last successful refresh in UTC (`YYYY-MM-DD HH:MM`). |
| `MATCHES` | Current-interface symbol names matched by `--query`. It is empty when the query matched the contract ID or name instead. |

### Flags

| Flag | Meaning |
| --- | --- |
| `-q`, `--query <text>` | Case-insensitive substring search over the contract ID, contract name, and current-interface function, type, and event names. |
| `--network <name>` | Restrict results to one network. An omitted value searches all stored networks. |
| `--limit <n>` | Maximum number of rows to return. The default is 50; values above 200 are clamped to 200. |
| `--offset <n>` | Skip this many rows before returning results. Defaults to `0`. |
| `--json` | Emit the page as JSON instead of the table. The JSON page contains `contracts` and `total`. |

Search uses only the interface version the contract currently runs. After an upgrade, symbols removed from the current interface no longer match; older interfaces remain available with `get --wasm-hash`. Searches are substring matches and are case-insensitive.

### Search examples

Register two contracts, then query once by a function name and once by a contract ID:

```console
$ sorovault add CDZZXVGUCLBUTE3WDD6TF2NXPTBPOYTVPPBBIZMSPVIQLUG226XJ4PAN CDZZZPYQALFRBQAZD5KCW2SZK4ZF455PJVD7H53AGHXTWAJO4BYVPP2V

$ sorovault list --query has_voted
CONTRACT ID                                                   NETWORK  WASM HASH       LAST REFRESHED     MATCHES
CDZZXVGUCLBUTE3WDD6TF2NXPTBPOYTVPPBBIZMSPVIQLUG226XJ4PAN     testnet  c618dae26486  <UTC minute>      has_voted

$ sorovault list --query CDZZZPYQALFRBQAZD5KCW2SZK4ZF455PJVD7H53AGHXTWAJO4BYVPP2V
CONTRACT ID                                                   NETWORK  WASM HASH       LAST REFRESHED     MATCHES
CDZZZPYQALFRBQAZD5KCW2SZK4ZF455PJVD7H53AGHXTWAJO4BYVPP2V     testnet  <current hash>  <UTC minute>
```

The first query matches the `has_voted` function, so its name appears in `MATCHES`. The second query matches the contract ID, so `MATCHES` is blank. The timestamp and the second contract's current hash depend on the registry state when the commands are run.

When no rows match, the human-readable command writes `no contracts registered` to stderr and exits successfully. The summary line for a non-empty result is written to stderr in the form `N of M contract(s)`.

## `sorovault get`

```console
sorovault get <contract_id> [flags]
```

Reads a stored interface. Without `--network`, it uses the network served by `RPC_URL`.

| Flag | Meaning |
| --- | --- |
| `--network <name>` | Read from this network instead of the network served by `RPC_URL`. |
| `--function <name>` | Print only one function, including its signature, inputs, and return type. |
| `--wasm-hash <hash>` | Read a specific stored interface version instead of the current one. |
| `--json` | Emit the ABI, or the selected function, as JSON. |

### Function output

The repository's real zkvote fixture uses this contract and function:

```console
$ sorovault get CDZZXVGUCLBUTE3WDD6TF2NXPTBPOYTVPPBBIZMSPVIQLUG226XJ4PAN --function has_voted
fn has_voted(nullifier: BytesN<32>) -> bool

inputs:
  nullifier  BytesN<32>

returns: bool
```

If the function name is unknown, the command returns an error such as `no function "..." in contract ...`.

### Reading a specific version

The same fixture stores this real WASM hash:

```console
$ sorovault get CDZZXVGUCLBUTE3WDD6TF2NXPTBPOYTVPPBBIZMSPVIQLUG226XJ4PAN --wasm-hash c618dae264864ccf446a3c7db27da80c7c83e840131242cc2fe9cd32a2a20781
CDZZXVGUCLBUTE3WDD6TF2NXPTBPOYTVPPBBIZMSPVIQLUG226XJ4PAN  (testnet)
wasm c618dae264864ccf446a3c7db27da80c7c83e840131242cc2fe9cd32a2a20781

  fn vote(voter: Address, proposal_index: u32, pub_signals: Vec<BytesN<32>>, a: BytesN<64>, b: BytesN<128>, c: BytesN<64>) -> Result<(), Error>
  fn has_voted(nullifier: BytesN<32>) -> bool
  fn initialize(admin: Address, verifier_id: Address, vote_params: VoteParams, proposal_descriptions: Vec<String>) -> Result<(), Error>
  fn get_proposal(index: u32) -> Result<Proposal, Error>
  fn get_total_votes() -> u64
  fn get_vote_params() -> Result<VoteParams, Error>
  fn get_proposal_count() -> u32

types:
  struct Proposal (2 fields)
  struct VoteParams (7 fields)
  error  Error (7 cases)

events:
  Voted (2 params)
```

Use `--wasm-hash` to inspect an older version after `refresh` records a new interface. Combining `--function` with `--wasm-hash` looks up the function inside that selected version; it does not change the current version.

Both commands accept `--json` when another program needs the complete machine-readable result.
