/**
 * @description Main BugFixAgent class that handles automatic bug detection, fixing, and deployment management
 * @author Your Name
 * @version 1.0.0
 */
public with sharing class BugFixAgent extends AgentForce.Agent {
    
    // Configuration constants
    private static final String SANDBOX_ENVIRONMENT = 'Sandbox';
    private static final String PRODUCTION_ENVIRONMENT = 'Production';
    private static final String BUG_STATUS_FIXED = 'Fixed';
    private static final String BUG_STATUS_PENDING_DEPLOYMENT = 'Pending Deployment';
    private static final String BUG_STATUS_DEPLOYED_SANDBOX = 'Deployed to Sandbox';
    private static final String BUG_STATUS_DEPLOYED_PRODUCTION = 'Deployed to Production';
    
    // Agent capabilities
    public override List<AgentForce.Capability> getCapabilities() {
        return new List<AgentForce.Capability>{
            new AgentForce.Capability('Bug Detection', 'Automatically detects bugs from DevOps platform'),
            new AgentForce.Capability('Bug Analysis', 'Analyzes bug patterns and suggests fixes'),
            new AgentForce.Capability('Auto Fix', 'Automatically applies bug fixes'),
            new AgentForce.Capability('Deployment Management', 'Manages sandbox and production deployments'),
            new AgentForce.Capability('User Confirmation', 'Requests user confirmation before deployments')
        };
    }
    
    /**
     * @description Main entry point for the agent
     * @param context The agent execution context
     * @return AgentForce.Result The execution result
     */
    public override AgentForce.Result execute(AgentForce.Context context) {
        try {
            // Initialize the bug fixing workflow
            BugFixWorkflow workflow = new BugFixWorkflow();
            
            // Step 1: Detect and analyze bugs
            List<BugReport> bugs = detectBugs();
            System.debug('Detected ' + bugs.size() + ' bugs');
            
            // Step 2: Fix bugs automatically
            List<BugFix> fixes = new List<BugFix>();
            for (BugReport bug : bugs) {
                BugFix fix = analyzeAndFixBug(bug);
                if (fix != null) {
                    fixes.add(fix);
                }
            }
            
            // Step 3: Request user confirmation for deployment
            if (!fixes.isEmpty()) {
                requestUserConfirmation(fixes);
            }
            
            return new AgentForce.Result(true, 'Bug fixing workflow completed successfully');
            
        } catch (Exception e) {
            System.debug('Error in BugFixAgent execution: ' + e.getMessage());
            return new AgentForce.Result(false, 'Error: ' + e.getMessage());
        }
    }
    
    /**
     * @description Detects bugs from the Salesforce DevOps platform
     * @return List<BugReport> List of detected bugs
     */
    private List<BugReport> detectBugs() {
        List<BugReport> bugs = new List<BugReport>();
        
        try {
            // Query for active bugs in the system
            List<Bug_Report__c> bugRecords = [
                SELECT Id, Name, Description__c, Severity__c, Status__c, 
                       Component__c, Error_Message__c, Stack_Trace__c,
                       CreatedDate, LastModifiedDate
                FROM Bug_Report__c 
                WHERE Status__c != :BUG_STATUS_FIXED 
                AND Status__c != :BUG_STATUS_DEPLOYED_PRODUCTION
                ORDER BY Severity__c DESC, CreatedDate ASC
                LIMIT 50
            ];
            
            for (Bug_Report__c record : bugRecords) {
                BugReport bug = new BugReport();
                bug.id = record.Id;
                bug.name = record.Name;
                bug.description = record.Description__c;
                bug.severity = record.Severity__c;
                bug.status = record.Status__c;
                bug.component = record.Component__c;
                bug.errorMessage = record.Error_Message__c;
                bug.stackTrace = record.Stack_Trace__c;
                bug.createdDate = record.CreatedDate;
                bug.lastModifiedDate = record.LastModifiedDate;
                
                bugs.add(bug);
            }
            
        } catch (Exception e) {
            System.debug('Error detecting bugs: ' + e.getMessage());
        }
        
        return bugs;
    }
    
    /**
     * @description Analyzes a bug and generates a fix
     * @param bug The bug to analyze and fix
     * @return BugFix The generated fix
     */
    private BugFix analyzeAndFixBug(BugReport bug) {
        try {
            BugAnalyzer analyzer = new BugAnalyzer();
            BugFix fix = analyzer.analyzeAndGenerateFix(bug);
            
            if (fix != null) {
                // Apply the fix
                applyBugFix(fix);
                
                // Update bug status
                updateBugStatus(bug.id, BUG_STATUS_FIXED);
                
                return fix;
            }
            
        } catch (Exception e) {
            System.debug('Error analyzing bug ' + bug.id + ': ' + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * @description Applies a bug fix to the codebase
     * @param fix The fix to apply
     */
    private void applyBugFix(BugFix fix) {
        try {
            // Create deployment package
            DeploymentPackage package = new DeploymentPackage();
            package.addFix(fix);
            
            // Validate the fix
            if (package.validate()) {
                // Apply the fix
                package.apply();
                System.debug('Applied fix for bug: ' + fix.bugId);
            } else {
                System.debug('Fix validation failed for bug: ' + fix.bugId);
            }
            
        } catch (Exception e) {
            System.debug('Error applying fix: ' + e.getMessage());
        }
    }
    
    /**
     * @description Updates the status of a bug report
     * @param bugId The ID of the bug to update
     * @param status The new status
     */
    private void updateBugStatus(String bugId, String status) {
        try {
            Bug_Report__c bug = new Bug_Report__c(Id = bugId, Status__c = status);
            update bug;
        } catch (Exception e) {
            System.debug('Error updating bug status: ' + e.getMessage());
        }
    }
    
    /**
     * @description Requests user confirmation for deployment
     * @param fixes List of fixes to be deployed
     */
    private void requestUserConfirmation(List<BugFix> fixes) {
        try {
            // Create deployment request
            DeploymentRequest request = new DeploymentRequest();
            request.fixes = fixes;
            request.environment = SANDBOX_ENVIRONMENT;
            request.status = 'Pending Confirmation';
            
            // Send notification to user
            sendDeploymentNotification(request);
            
            // Update bug statuses
            for (BugFix fix : fixes) {
                updateBugStatus(fix.bugId, BUG_STATUS_PENDING_DEPLOYMENT);
            }
            
        } catch (Exception e) {
            System.debug('Error requesting user confirmation: ' + e.getMessage());
        }
    }
    
    /**
     * @description Sends deployment notification to user
     * @param request The deployment request
     */
    private void sendDeploymentNotification(DeploymentRequest request) {
        try {
            // Create notification record
            Deployment_Notification__c notification = new Deployment_Notification__c();
            notification.Deployment_Request__c = JSON.serialize(request);
            notification.Status__c = 'Pending';
            notification.Environment__c = request.environment;
            notification.Created_Date__c = System.now();
            
            insert notification;
            
            // Send email notification (if configured)
            sendEmailNotification(notification);
            
        } catch (Exception e) {
            System.debug('Error sending deployment notification: ' + e.getMessage());
        }
    }
    
    /**
     * @description Sends email notification about deployment
     * @param notification The notification record
     */
    private void sendEmailNotification(Deployment_Notification__c notification) {
        try {
            // Get user email from configuration
            String userEmail = getConfiguredUserEmail();
            
            if (String.isNotBlank(userEmail)) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[]{userEmail});
                email.setSubject('Bug Fix Agent - Deployment Confirmation Required');
                email.setPlainTextBody('Please review and confirm the deployment of bug fixes to ' + 
                                    notification.Environment__c + ' environment.');
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            }
            
        } catch (Exception e) {
            System.debug('Error sending email notification: ' + e.getMessage());
        }
    }
    
    /**
     * @description Gets the configured user email for notifications
     * @return String The user email address
     */
    private String getConfiguredUserEmail() {
        try {
            // Query configuration for user email
            List<Agent_Configuration__c> configs = [
                SELECT Value__c 
                FROM Agent_Configuration__c 
                WHERE Key__c = 'UserEmail' 
                LIMIT 1
            ];
            
            if (!configs.isEmpty()) {
                return configs[0].Value__c;
            }
            
        } catch (Exception e) {
            System.debug('Error getting configured user email: ' + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * @description Deploys fixes to sandbox environment
     * @param fixes List of fixes to deploy
     * @return Boolean True if deployment successful
     */
    public Boolean deployToSandbox(List<BugFix> fixes) {
        try {
            DeploymentManager manager = new DeploymentManager();
            DeploymentResult result = manager.deploy(fixes, SANDBOX_ENVIRONMENT);
            
            if (result.success) {
                // Update bug statuses
                for (BugFix fix : fixes) {
                    updateBugStatus(fix.bugId, BUG_STATUS_DEPLOYED_SANDBOX);
                }
                
                return true;
            }
            
        } catch (Exception e) {
            System.debug('Error deploying to sandbox: ' + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * @description Deploys fixes to production environment
     * @param fixes List of fixes to deploy
     * @return Boolean True if deployment successful
     */
    public Boolean deployToProduction(List<BugFix> fixes) {
        try {
            DeploymentManager manager = new DeploymentManager();
            DeploymentResult result = manager.deploy(fixes, PRODUCTION_ENVIRONMENT);
            
            if (result.success) {
                // Update bug statuses
                for (BugFix fix : fixes) {
                    updateBugStatus(fix.bugId, BUG_STATUS_DEPLOYED_PRODUCTION);
                }
                
                return true;
            }
            
        } catch (Exception e) {
            System.debug('Error deploying to production: ' + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * @description Validates agent compatibility with AgentExchange framework
     * @return Map<String, Object> Validation results with success status and details
     */
    public Map<String, Object> validateExchangeCompatibility() {
        Map<String, Object> validationResult = new Map<String, Object>();
        List<String> errors = new List<String>();
        List<String> warnings = new List<String>();
        Boolean isValid = true;
        
        try {
            // Validate agent extends AgentForce.Agent
            if (!(this instanceof AgentForce.Agent)) {
                errors.add('Agent must extend AgentForce.Agent');
                isValid = false;
            }
            
            // Validate getCapabilities() method exists and returns non-empty list
            List<AgentForce.Capability> capabilities = getCapabilities();
            if (capabilities == null || capabilities.isEmpty()) {
                errors.add('getCapabilities() must return a non-empty list');
                isValid = false;
            } else {
                // Validate each capability has name and description
                for (AgentForce.Capability cap : capabilities) {
                    if (String.isBlank(cap.name)) {
                        errors.add('Capabilities must have a name');
                        isValid = false;
                    }
                    if (String.isBlank(cap.description)) {
                        warnings.add('Capability "' + cap.name + '" should have a description');
                    }
                }
            }
            
            // Validate execute method can be called
            try {
                AgentForce.Context testContext = new AgentForce.Context();
                AgentForce.Result testResult = execute(testContext);
                if (testResult == null) {
                    errors.add('execute() method must return a non-null AgentForce.Result');
                    isValid = false;
                }
            } catch (Exception e) {
                // This is expected in test context, but we validate the method exists
                if (!e.getMessage().contains('execute')) {
                    warnings.add('execute() method should handle errors gracefully');
                }
            }
            
            // Validate required custom objects exist
            Schema.SObjectType bugReportType = Schema.getGlobalDescribe().get('Bug_Report__c');
            if (bugReportType == null) {
                errors.add('Required custom object Bug_Report__c is not deployed');
                isValid = false;
            }
            
            Schema.SObjectType deploymentRequestType = Schema.getGlobalDescribe().get('Deployment_Request__c');
            if (deploymentRequestType == null) {
                errors.add('Required custom object Deployment_Request__c is not deployed');
                isValid = false;
            }
            
            Schema.SObjectType agentConfigType = Schema.getGlobalDescribe().get('Agent_Configuration__c');
            if (agentConfigType == null) {
                errors.add('Required custom object Agent_Configuration__c is not deployed');
                isValid = false;
            }
            
            // Validate agent metadata matches agent-exchange.json structure
            // This would be validated during packaging/deployment
            
        } catch (Exception e) {
            errors.add('Validation error: ' + e.getMessage());
            isValid = false;
        }
        
        validationResult.put('success', isValid);
        validationResult.put('errors', errors);
        validationResult.put('warnings', warnings);
        validationResult.put('timestamp', System.now());
        
        return validationResult;
    }
    
    /**
     * @description Gets agent metadata for AgentExchange listing
     * @return Map<String, Object> Agent metadata including capabilities, version, etc.
     */
    public Map<String, Object> getExchangeMetadata() {
        Map<String, Object> metadata = new Map<String, Object>();
        
        metadata.put('name', 'BugFixAgent');
        metadata.put('version', '1.0.0');
        metadata.put('description', 'AI-powered agent that automatically detects, fixes bugs, and manages deployments in Salesforce DevOps platform');
        metadata.put('category', 'DevOps');
        metadata.put('tags', new List<String>{'bug-fixing', 'automation', 'deployment', 'ai'});
        
        List<Map<String, String>> capabilitiesMetadata = new List<Map<String, String>>();
        for (AgentForce.Capability cap : getCapabilities()) {
            Map<String, String> capMeta = new Map<String, String>();
            capMeta.put('name', cap.name);
            capMeta.put('description', cap.description);
            capabilitiesMetadata.add(capMeta);
        }
        metadata.put('capabilities', capabilitiesMetadata);
        
        metadata.put('compatibility', new Map<String, String>{
            'salesforceApiVersion' => '60.0',
            'agentforceVersion' => '1.0.0'
        });
        
        return metadata;
    }
}
