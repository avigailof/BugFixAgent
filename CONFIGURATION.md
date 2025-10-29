# BugFixAgent Configuration Guide

## Initial Setup

### 1. Agent Configuration Records

Create the following records in `Agent_Configuration__c`:

```apex
// User Email Configuration
Agent_Configuration__c userEmail = new Agent_Configuration__c();
userEmail.Key__c = 'UserEmail';
userEmail.Value__c = 'your.email@example.com';
userEmail.Description__c = 'Email address for deployment notifications';
userEmail.Category__c = 'Notification';
userEmail.Is_Active__c = true;
insert userEmail;

// Maximum Bugs Per Run
Agent_Configuration__c maxBugs = new Agent_Configuration__c();
maxBugs.Key__c = 'MaxBugsPerRun';
maxBugs.Value__c = '50';
maxBugs.Description__c = 'Maximum number of bugs to process per run';
maxBugs.Category__c = 'Performance';
maxBugs.Is_Active__c = true;
insert maxBugs;

// Minimum Fix Confidence
Agent_Configuration__c minConfidence = new Agent_Configuration__c();
minConfidence.Key__c = 'MinFixConfidence';
minConfidence.Value__c = '70';
minConfidence.Description__c = 'Minimum confidence threshold for auto-fixing';
minConfidence.Category__c = 'Quality';
minConfidence.Is_Active__c = true;
insert minConfidence;

// Deployment Timeout
Agent_Configuration__c timeout = new Agent_Configuration__c();
timeout.Key__c = 'DeploymentTimeout';
timeout.Value__c = '30';
timeout.Description__c = 'Deployment timeout in minutes';
timeout.Category__c = 'Performance';
timeout.Is_Active__c = true;
insert timeout;

// Debug Mode
Agent_Configuration__c debugMode = new Agent_Configuration__c();
debugMode.Key__c = 'DebugMode';
debugMode.Value__c = 'false';
debugMode.Description__c = 'Enable debug logging';
debugMode.Category__c = 'Debug';
debugMode.Is_Active__c = true;
insert debugMode;
```

### 2. Sample Bug Reports

Create sample bug reports for testing:

```apex
// High Severity Bug
Bug_Report__c bug1 = new Bug_Report__c();
bug1.Description__c = 'Null pointer exception in Account trigger when processing bulk updates';
bug1.Severity__c = 'Critical';
bug1.Status__c = 'New';
bug1.Component__c = 'AccountTrigger';
bug1.Error_Message__c = 'System.NullPointerException: Attempt to de-reference a null object';
bug1.Stack_Trace__c = 'AccountTrigger: line 5, column 1\nAccountTriggerHandler: line 10, column 1';
insert bug1;

// Medium Severity Bug
Bug_Report__c bug2 = new Bug_Report__c();
bug2.Description__c = 'List exception in Contact query when no records found';
bug2.Severity__c = 'High';
bug2.Status__c = 'In Progress';
bug2.Component__c = 'ContactController';
bug2.Error_Message__c = 'System.ListException: List index out of bounds: 0';
bug2.Stack_Trace__c = 'ContactController: line 15, column 1';
insert bug2;

// Low Severity Bug
Bug_Report__c bug3 = new Bug_Report__c();
bug3.Description__c = 'DML exception when inserting duplicate records';
bug3.Severity__c = 'Medium';
bug3.Status__c = 'New';
bug3.Component__c = 'LeadProcessor';
bug3.Error_Message__c = 'System.DmlException: Insert failed';
bug3.Stack_Trace__c = 'LeadProcessor: line 20, column 1';
insert bug3;
```

## Usage Examples

### 1. Running the Agent

```apex
// Execute the complete bug fixing workflow
BugFixWorkflow workflow = new BugFixWorkflow();
WorkflowResult result = workflow.executeWorkflow();

System.debug('Workflow Result: ' + result);
System.debug('Detected Bugs: ' + result.detectedBugs);
System.debug('Generated Fixes: ' + result.generatedFixes);
System.debug('Status: ' + result.status);
```

### 2. Manual Bug Analysis

```apex
// Analyze a specific bug
BugAnalyzer analyzer = new BugAnalyzer();

BugReport bug = new BugReport();
bug.id = 'your-bug-id';
bug.name = 'Test Bug';
bug.description = 'Test description';
bug.severity = 'High';
bug.component = 'TestComponent';
bug.errorMessage = 'System.NullPointerException: Attempt to de-reference a null object';
bug.stackTrace = 'TestClass: line 5, column 1';

BugFix fix = analyzer.analyzeAndGenerateFix(bug);
System.debug('Generated Fix: ' + fix);
```

### 3. Manual Deployment

```apex
// Deploy fixes to sandbox
BugFixAgent agent = new BugFixAgent();

BugFix fix = new BugFix();
fix.bugId = 'your-bug-id';
fix.codeFix = 'if (obj != null) { /* fix code */ }';

List<BugFix> fixes = new List<BugFix>{fix};
Boolean success = agent.deployToSandbox(fixes);

System.debug('Sandbox Deployment Success: ' + success);
```

### 4. API Usage

```javascript
// Get bug reports via REST API
fetch('/services/apexrest/bugfixagent/?status=New&severity=High', {
    method: 'GET',
    headers: {
        'Authorization': 'Bearer ' + sessionId,
        'Content-Type': 'application/json'
    }
})
.then(response => response.json())
.then(data => {
    console.log('Bug Reports:', data);
});

// Trigger workflow via REST API
fetch('/services/apexrest/bugfixagent/workflow', {
    method: 'POST',
    headers: {
        'Authorization': 'Bearer ' + sessionId,
        'Content-Type': 'application/json'
    }
})
.then(response => response.json())
.then(data => {
    console.log('Workflow Result:', data);
});

// Process deployment confirmation
fetch('/services/apexrest/bugfixagent/confirm', {
    method: 'POST',
    headers: {
        'Authorization': 'Bearer ' + sessionId,
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({
        requestId: 'deployment-request-id',
        confirmed: true,
        environment: 'Sandbox'
    })
})
.then(response => response.json())
.then(data => {
    console.log('Confirmation Result:', data);
});
```

## Monitoring and Troubleshooting

### 1. Check Agent Status

```apex
// Query agent configuration
List<Agent_Configuration__c> configs = [
    SELECT Key__c, Value__c, Is_Active__c
    FROM Agent_Configuration__c
    WHERE Is_Active__c = true
];

for (Agent_Configuration__c config : configs) {
    System.debug(config.Key__c + ': ' + config.Value__c);
}
```

### 2. Monitor Bug Reports

```apex
// Query bug reports by status
List<Bug_Report__c> bugs = [
    SELECT Id, Name, Status__c, Severity__c, Fix_Applied__c, Fix_Confidence__c
    FROM Bug_Report__c
    WHERE Status__c IN ('New', 'In Progress', 'Fixed')
    ORDER BY Severity__c DESC, CreatedDate ASC
];

for (Bug_Report__c bug : bugs) {
    System.debug('Bug: ' + bug.Name + ' - Status: ' + bug.Status__c + ' - Confidence: ' + bug.Fix_Confidence__c);
}
```

### 3. Check Deployment History

```apex
// Query deployment history
List<Deployment_Request__c> deployments = [
    SELECT Id, Environment__c, Status__c, Requested_Date__c, Deployment_Date__c
    FROM Deployment_Request__c
    ORDER BY Requested_Date__c DESC
    LIMIT 10
];

for (Deployment_Request__c deployment : deployments) {
    System.debug('Deployment: ' + deployment.Id + ' - Environment: ' + deployment.Environment__c + ' - Status: ' + deployment.Status__c);
}
```

### 4. Debug Mode

Enable debug mode for detailed logging:

```apex
Agent_Configuration__c debugConfig = [
    SELECT Id, Value__c
    FROM Agent_Configuration__c
    WHERE Key__c = 'DebugMode'
    LIMIT 1
];

debugConfig.Value__c = 'true';
update debugConfig;
```

## Best Practices

### 1. Regular Monitoring
- Check bug reports daily
- Monitor deployment success rates
- Review fix confidence scores

### 2. Configuration Management
- Keep configuration values up to date
- Test changes in sandbox first
- Document configuration changes

### 3. Error Handling
- Monitor error logs regularly
- Set up alerts for critical failures
- Maintain backup configurations

### 4. Performance Optimization
- Limit the number of bugs processed per run
- Use appropriate confidence thresholds
- Monitor execution times

### 5. Security
- Regularly review user permissions
- Secure API endpoints
- Audit agent activities

## Troubleshooting Common Issues

### Issue: Agent not detecting bugs
**Solution**: Check if `Bug_Report__c` records exist and have proper status values.

### Issue: Fixes not being generated
**Solution**: Verify error messages and stack traces are populated in bug reports.

### Issue: Deployment failures
**Solution**: Check deployment logs and verify environment connectivity.

### Issue: Email notifications not sent
**Solution**: Verify `UserEmail` configuration and email deliverability settings.

### Issue: Low fix confidence scores
**Solution**: Ensure bug reports have detailed error messages and stack traces.
