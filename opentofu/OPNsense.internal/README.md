# OPNsense.internal

My router, running OPNsense on a Protectli Vault FW4C.

OpenTofu can't install an OS on bare metal, so getting OPNsense onto the
FW4C itself is a one-time manual step. Everything after that (firewall
rules, DHCP, DNS overrides, aliases, etc.) is managed declaratively here
via the OPNsense REST API, using the community
[`browningluke/opnsense`](https://github.com/browningluke/terraform-provider-opnsense)
provider. Note: this provider is actively developed but explicitly not
recommended for production use — an acceptable tradeoff for a homelab
router.

## One-time manual setup (on the FW4C)

1. Flash/install OPNsense on the FW4C using the official installer image
   and the console setup wizard.
2. During the wizard, assign interfaces: one port as WAN, the remaining
   port(s) as LAN. This base interface assignment isn't exposed by the
   OPNsense API, so it isn't managed by this Tofu config.
3. In the web UI, go to *System → Access → Users*, create (or use the
   existing) API user, and generate an API key/secret under that user's
   settings.
4. If using the default self-signed certificate, you'll need
   `allow_insecure = true` below (or install a trusted cert).

## Secrets

The API key/secret are stored in `secrets/OPNsense.internal/secrets.yaml`,
encrypted with the same sops-nix setup used everywhere else in this repo.
Edit it with:

```sh
sops secrets/OPNsense.internal/secrets.yaml
```

and set:

```yaml
api_key: "..."
api_secret: "..."
```

This reuses the age key already generated for user `aaron` via
home-manager (`~/.config/sops/age/keys.txt`) — no separate credential
setup needed. The file is safe to commit since it's encrypted; the
`carlpett/sops` provider decrypts it into the `opnsense` provider config
at plan/apply time via an ephemeral resource, so the secret is never
written to `terraform.tfstate`.

## Usage

```sh
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars with your router's URI and LAN subnet

tofu init
tofu plan
tofu apply
```

`terraform.tfvars` and all state files are gitignored since they hold
sensitive data — never commit them.
