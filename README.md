# BugFixAgent - AI-Powered Bug Fixing Agent

## Overview

BugFixAgent is an intelligent AI agent built on Salesforce AgentForce that automatically detects, analyzes, and fixes bugs in your Salesforce DevOps platform. It provides automated bug fixing capabilities with user confirmation workflows for safe deployments to sandbox and production environments.

## Features

### 🔍 **Automatic Bug Detection**
- Scans Salesforce DevOps platform for active bugs
- Prioritizes bugs by severity and creation date
- Supports filtering by status, severity, and component

### 🧠 **AI-Powered Bug Analysis**
- Analyzes error messages and stack traces
- Identifies common Salesforce exceptions
- Generates contextual fix descriptions
- Calculates confidence scores for fixes

### 🔧 **Automatic Bug Fixing**
- Generates code fixes for common error types
- Supports fixes for:
  - NullPointerException
  - ListException
  - DmlException
  - QueryException
  - LimitException
  - ValidationException
  - DuplicateValueException

### 🚀 **Deployment Management**
- User confirmation workflow before deployments
- Sandbox deployment with validation
- Production deployment with safety checks
- Deployment history tracking

### 📧 **Notification System**
- Email notifications for deployment confirmations
- Status updates for bug fixes
- Error notifications with detailed information

## Installation

### Prerequisites
- Salesforce org with AgentForce enabled
- API access for DevOps platform integration
- Custom objects deployed (see below)

### Step 1: Deploy Custom Objects
Deploy the following custom objects to your org:
- `Bug_Report__c` - Stores bug reports
- `Deployment_Request__c` - Manages deployment requests
- `Deployment_Notification__c` - Handles notifications
- `Agent_Configuration__c` - Stores agent settings

### Step 2: Deploy Agent Classes
Deploy all Apex classes to your org:
- `BugFixAgent` - Main agent class
- `BugAnalyzer` - Bug analysis engine
- `DeploymentManager` - Deployment management
- `BugFixWorkflow` - Workflow orchestration
- `BugFixAgentAPI` - REST API endpoints

### Step 3: Configure Agent Settings
Create configuration records in `Agent_Configuration__c`:

| Key | Value | Description |
|-----|-------|-------------|
| `UserEmail` | `your.email@example.com` | Email for notifications |
| `MaxBugsPerRun` | `50` | Max bugs per execution |
| `MinFixConfidence` | `70` | Min confidence threshold |
| `DeploymentTimeout` | `30` | Deployment timeout (minutes) |

### Step 4: Test the Agent
1. Create sample bug reports
2. Execute the agent workflow
3. Verify notifications are sent
4. Test deployment confirmations

## Usage

### Running the Agent
```apex
// Execute the bug fixing workflow
BugFixWorkflow workflow = new BugFixWorkflow();
WorkflowResult result = workflow.executeWorkflow();
```

### API Endpoints
The agent provides REST API endpoints for integration:

- `GET /services/apexrest/bugfixagent/` - Get bug reports
- `POST /services/apexrest/bugfixagent/` - Create bug report
- `PUT /services/apexrest/bugfixagent/` - Update bug status
- `POST /services/apexrest/bugfixagent/workflow` - Trigger workflow
- `POST /services/apexrest/bugfixagent/confirm` - Process deployment confirmation

### Example API Usage
```javascript
// Get bug reports
fetch('/services/apexrest/bugfixagent/?status=New&severity=High')
  .then(response => response.json())
  .then(data => console.log(data));

// Trigger workflow
fetch('/services/apexrest/bugfixagent/workflow', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' }
})
  .then(response => response.json())
  .then(data => console.log(data));
```

## Configuration

### Agent Settings
Configure the agent behavior through `Agent_Configuration__c` records:

- **UserEmail**: Email address for deployment notifications
- **MaxBugsPerRun**: Maximum bugs to process per execution
- **MinFixConfidence**: Minimum confidence threshold for auto-fixing
- **DeploymentTimeout**: Deployment timeout in minutes

### Bug Report Fields
The `Bug_Report__c` object includes:
- **Description**: Detailed bug description
- **Severity**: Critical, High, Medium, Low
- **Status**: New, In Progress, Fixed, etc.
- **Component**: Affected component
- **Error Message**: Error details
- **Stack Trace**: Full stack trace
- **Fix Applied**: Boolean flag
- **Fix Confidence**: Confidence score
- **Fix Code**: Generated fix code

## Workflow

1. **Bug Detection**: Agent scans for active bugs
2. **Analysis**: AI analyzes each bug and generates fixes
3. **Fix Generation**: Code fixes are generated with confidence scores
4. **User Notification**: Email sent requesting deployment confirmation
5. **Deployment**: After confirmation, fixes deployed to sandbox/production
6. **Status Update**: Bug statuses updated throughout the process

## Error Handling

The agent includes comprehensive error handling:
- Validation of deployment packages
- Rollback capabilities for failed deployments
- Detailed error logging and reporting
- Graceful handling of API failures

## Security

- All API endpoints require proper authentication
- User confirmation required for all deployments
- Audit trail for all agent actions
- Secure handling of sensitive data

## Troubleshooting

### Common Issues

1. **Agent not detecting bugs**
   - Check `Bug_Report__c` records exist
   - Verify agent has proper permissions
   - Check configuration settings

2. **Deployment failures**
   - Review error messages in deployment history
   - Check environment connectivity
   - Verify fix validation

3. **Email notifications not sent**
   - Check `UserEmail` configuration
   - Verify email deliverability settings
   - Review notification records

### Debug Mode
Enable debug logging by setting the `DebugMode` configuration to `true`.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the GitHub repository
- Contact the author at your.email@example.com
- Check the Salesforce AgentForce documentation

## Changelog

### Version 1.0.0
- Initial release
- Basic bug detection and fixing
- Deployment management
- User confirmation workflow
- REST API integration
