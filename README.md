# iac-atom-datafactory

A cloud-specific Terraform atom for provisioning Azure Data Factory instances as part of an atom-molecule-template infrastructure architecture.

## Traffic Light System

This repository implements a **traffic light system** for CI/CD pipeline control using structured commit messages. Since Azure Data Factory is Azure-specific, only Azure-related CI tools are supported.

### Commit Message Convention

All commit messages must follow this format:
```
[repo] [cloud] [ci-tool] [action] <description>
```

**Components:**
- `[repo]`: Repository platform - `[github]`
- `[cloud]`: Target cloud provider - `[azure]` (only)
- `[ci-tool]`: CI/CD platform - `[ado]`, `[gh_actions]`
- `[action]`: Pipeline action - `[build]`, `[release]`

**Examples:**
```bash
# Build and validate Azure Data Factory using Azure DevOps
git commit -m "[github] [azure] [ado] [build] fix: update data factory configuration"

# Build and validate using GitHub Actions
git commit -m "[github] [azure] [gh_actions] [build] feat: add managed virtual network"

# Create release PR using Azure DevOps
git commit -m "[github] [azure] [ado] [release] feat: ready for release"
```

### Pipeline Execution Matrix

| Commit Message | Azure DevOps | GitHub Actions |
|---|---|---|
| `[github] [azure] [ado] [build]` | ✅ Run | ❌ Skip |
| `[github] [azure] [gh_actions] [release]` | ❌ Skip | ✅ Run |

## Architecture Overview

This repository follows the **atom-molecule-template** design pattern:

- **Atoms**: Individual infrastructure components (this Data Factory atom)
- **Molecules**: Compositions of atoms that create functional units
- **Templates**: Complete application stacks that consume molecules

## Current Implementation

### Azure Data Factory (`iac/terraform/azure/`)
- **Resource**: Azure Data Factory v2
- **Features**: System-assigned managed identity, GitHub integration, managed virtual network support
- **Security**: Configurable public network access
- **State**: Terraform Cloud workspace (`datafactory-azure-dev`)
- **Outputs**: Data Factory ID, name, and managed identity details

### Module Structure
- `main.tf` - Core Data Factory resource definition
- `variables.tf` - Input parameters
- `outputs.tf` - Exposed values for consumption
- `backend.tf` - Terraform Cloud configuration
- `versions.tf` - Terraform version constraints

## Usage

### Module Publication
Modules are automatically published to Terraform Cloud and referenced by URI:

```hcl
module "data_factory" {
  source  = "app.terraform.io/vpapakir/datafactory/azure"
  version = "~> 1.0"
  
  name                = "adf-myapp-dev"
  location            = "East US"
  resource_group_name = "rg-myapp-dev"
  
  public_network_enabled          = true
  managed_virtual_network_enabled = true
  
  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

### Release Workflow

#### 1. Development
```bash
git commit -m "[github] [azure] [ado] [build] feat: add new data factory features"
git push origin feature-branch
```
- Runs validation on Azure Data Factory module
- Tests example configuration

#### 2. Release Intent
```bash
git commit -m "[github] [azure] [ado] [release] feat: ready for release"
git push origin feature-branch
```
- Creates automated PR to main branch
- Requires team review and approval

#### 3. Automatic Publication
- Reviewer approves PR with version message
- PR merge triggers pipeline on main branch
- Publishes versioned module to Terraform Cloud

## Pipeline Configuration

### Centralized Pipeline Templates
Pipeline templates are sourced from the centralized `iac-pipeline-templates` repository:
- **Template Repository**: https://github.com/vpapakir/iac-pipeline-templates
- **Current Version**: `v0.0.15`
- **Azure-Specific**: Only Azure DevOps and GitHub Actions supported

### Azure DevOps (`.azure/pipeline.yml`)
- **Template**: `azure/stages/traffic-light-pipeline.yml@templates`
- **Version**: `v0.0.15`
- **Variable Groups**: `terraform` (TF_CLOUD_TOKEN), `shared` (GITHUB_TOKEN, Azure credentials)
- **Stages**: CommitCheck → Build → CreatePR → Publish

### GitHub Actions (`.github/workflows/pipeline.yml`)
- **Workflow**: `vpapakir/iac-pipeline-templates/.github/workflows/traffic-light-pipeline.yml@v0.0.15`
- **Secrets**: `TF_CLOUD_TOKEN`, `GITHUB_TOKEN`
- **Jobs**: commit-check → build → create-pr → publish

## Repository Structure

```
iac-atom-datafactory/
├── .azure/                    # Azure DevOps pipeline definitions
│   └── pipeline.yml           # Main pipeline using centralized templates
├── .github/                   # GitHub Actions workflows
│   └── workflows/
│       └── pipeline.yml       # Traffic light pipeline
├── examples/                  # Pipeline testing examples
│   └── azure-example/         # Azure Data Factory usage example
├── iac/
│   └── terraform/
│       └── azure/             # Azure Data Factory module
├── .gitignore
├── LICENSE
└── README.md
```

## Contributing

This atom implements the **traffic light system** for clean CI/CD pipeline control:

1. **Follow commit message convention** - Use `[github] [azure] [ci-tool] [action]` format
2. **Azure-specific only** - Only `[azure]` cloud provider supported
3. **Use build for development** - Validate changes with `[build]` action
4. **Use release for PR creation** - Create PRs with `[release]` action
5. **Control module publishing** - Choose CI tool in PR approval message

### Quick Reference

```bash
# Development testing
git commit -m "[github] [azure] [ado] [build] fix: update data factory settings"

# Ready for release
git commit -m "[github] [azure] [gh_actions] [release] feat: new data factory features"

# PR approval (in GitHub PR comment)
"[APPROVED] [MINOR] [gh_actions] new features look good"
```

## License

See [LICENSE](LICENSE) file for details.