# Using the tools together

Each SoroWorks tool works alone. Connected, they form one pipeline: SoroForge **deploys** and tells SoroVault, SoroVault **catalogs** the interface, and SoroProbe **verifies** the contract using that interface.

```
 soroforge deploy ──POST /api/contracts──▶ SoroVault ◀──GET /api/contracts/{id}── soroprobe simulate
   (records history)                    (decodes & versions the ABI)            (types arguments from it)
```

Two settings connect them, and both are optional.

## 1. Run a SoroVault for your network

```bash
git clone https://github.com/soroworks/sorovault && cd sorovault
REFRESH_INTERVAL=6h make up      # Postgres + migrations + server on :8080
```

`REFRESH_INTERVAL` makes SoroVault notice upgrades made outside SoroForge too.

## 2. Point SoroForge at it

In `soroforge.yaml`, give the network a `sorovault_url`:

```yaml
networks:
  testnet:
    rpc_url: https://soroban-testnet.stellar.org
    passphrase: "Test SDF Network ; September 2015"
    sorovault_url: http://localhost:8080
```

Now every confirmed deploy and upgrade is registered:

```
$ soroforge deploy counter --network testnet
Deployed counter to testnet.

  Contract ID   CCLV77FY…RDSR4
  …
  SoroVault     http://localhost:8080/api/contracts/CCLV77FY…RDSR4?network=testnet (3 functions)
```

Registration only happens after on-chain confirmation, and a registry outage never fails the deploy.

## 3. Point SoroProbe at it

```bash
export SOROVAULT_URL=http://localhost:8080
soroprobe simulate CCLV77FY…RDSR4 set_count 5
```

```
contract CCLV77FY…RDSR4
function fn set_count(value: u32)
encoded  u32:5
```

Without the registry, `5` would be inferred as an `i128` and a contract expecting `u32` would reject it. With it, SoroProbe uses the declared type, and refuses a misspelled function or a wrong argument count before anything is simulated.

## In CI

A typical pipeline deploys, then gates on health:

```bash
soroforge deploy counter --network testnet --json > deploy.json
CONTRACT=$(jq -r .contract_id deploy.json)
soroprobe check "$CONTRACT" --fn get_count     # exit 1 if unhealthy, 2 if the tool could not run
soroforge status --all --network testnet       # exit 2 if any tracked contract drifted
```
