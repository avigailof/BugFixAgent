/**
 * @description Manages the bug fixing workflow
 * @author Your Name
 * @version 1.0.0
 */
public class BugFixWorkflow {
    
    private BugAnalyzer analyzer;
    private DeploymentManager deploymentManager;
    
    public BugFixWorkflow() {
        this.analyzer = new BugAnalyzer();
        this.deploymentManager = new DeploymentManager();
    }
    
    /**
     * @description Executes the complete bug fixing workflow
     * @return WorkflowResult The workflow execution result
     */
    public WorkflowResult executeWorkflow() {
        WorkflowResult result = new WorkflowResult();
        result.startTime = System.now();
        
        try {
            // Step 1: Detect bugs
            List<BugReport> bugs = detectBugs();
            result.detectedBugs = bugs.size();
            
            // Step 2: Analyze and fix bugs
            List<BugFix> fixes = new List<BugFix>();
            for (BugReport bug : bugs) {
                BugFix fix = analyzer.analyzeAndGenerateFix(bug);
                if (fix != null) {
                    fixes.add(fix);
                }
            }
            result.generatedFixes = fixes.size();
            
            // Step 3: Request user confirmation
            if (!fixes.isEmpty()) {
                requestUserConfirmation(fixes);
                result.status = 'Awaiting User Confirmation';
            } else {
                result.status = 'No Fixes Generated';
            }
            
            result.success = true;
            
        } catch (Exception e) {
            result.success = false;
            result.errorMessage = e.getMessage();
            result.status = 'Error';
        }
        
        result.endTime = System.now();
        result.duration = result.endTime.getTime() - result.startTime.getTime();
        
        return result;
    }
    
    /**
     * @description Detects bugs from the system
     * @return List<BugReport> List of detected bugs
     */
    private List<BugReport> detectBugs() {
        List<BugReport> bugs = new List<BugReport>();
        
        try {
            // Query for active bugs
            List<Bug_Report__c> bugRecords = [
                SELECT Id, Name, Description__c, Severity__c, Status__c,
                       Component__c, Error_Message__c, Stack_Trace__c,
                       CreatedDate, LastModifiedDate
                FROM Bug_Report__c
                WHERE Status__c IN ('New', 'In Progress', 'Reopened')
                ORDER BY Severity__c DESC, CreatedDate ASC
                LIMIT 100
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
     * @description Requests user confirmation for deployment
     * @param fixes List of fixes to deploy
     */
    private void requestUserConfirmation(List<BugFix> fixes) {
        try {
            // Create deployment request
            DeploymentRequest request = new DeploymentRequest();
            request.fixes = fixes;
            request.environment = 'Sandbox';
            request.status = 'Pending Confirmation';
            request.requestedBy = UserInfo.getUserId();
            
            // Save deployment request
            saveDeploymentRequest(request);
            
            // Send notification
            sendDeploymentNotification(request);
            
        } catch (Exception e) {
            System.debug('Error requesting user confirmation: ' + e.getMessage());
        }
    }
    
    /**
     * @description Saves deployment request to database
     * @param request The deployment request
     */
    private void saveDeploymentRequest(DeploymentRequest request) {
        try {
            Deployment_Request__c record = new Deployment_Request__c();
            record.Fixes__c = JSON.serialize(request.fixes);
            record.Environment__c = request.environment;
            record.Status__c = request.status;
            record.Requested_By__c = request.requestedBy;
            record.Requested_Date__c = request.requestedDate;
            record.Comments__c = request.comments;
            
            insert record;
            
        } catch (Exception e) {
            System.debug('Error saving deployment request: ' + e.getMessage());
        }
    }
    
    /**
     * @description Sends deployment notification
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
            
            // Send email notification
            sendEmailNotification(notification);
            
        } catch (Exception e) {
            System.debug('Error sending deployment notification: ' + e.getMessage());
        }
    }
    
    /**
     * @description Sends email notification
     * @param notification The notification record
     */
    private void sendEmailNotification(Deployment_Notification__c notification) {
        try {
            // Get user email
            String userEmail = getConfiguredUserEmail();
            
            if (String.isNotBlank(userEmail)) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[]{userEmail});
                email.setSubject('Bug Fix Agent - Deployment Confirmation Required');
                
                String body = 'The Bug Fix Agent has generated fixes for bugs and is requesting confirmation to deploy to ' +
                            notification.Environment__c + ' environment.\n\n' +
                            'Please review the fixes and confirm the deployment.\n\n' +
                            'Notification ID: ' + notification.Id;
                
                email.setPlainTextBody(body);
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            }
            
        } catch (Exception e) {
            System.debug('Error sending email notification: ' + e.getMessage());
        }
    }
    
    /**
     * @description Gets configured user email
     * @return String The user email address
     */
    private String getConfiguredUserEmail() {
        try {
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
     * @description Processes user confirmation
     * @param requestId The deployment request ID
     * @param confirmed Whether the user confirmed the deployment
     * @param environment The target environment
     * @return Boolean True if processing successful
     */
    public Boolean processUserConfirmation(String requestId, Boolean confirmed, String environment) {
        try {
            // Get deployment request
            Deployment_Request__c request = [
                SELECT Id, Fixes__c, Status__c
                FROM Deployment_Request__c
                WHERE Id = :requestId
                LIMIT 1
            ];
            
            if (confirmed) {
                // Parse fixes
                List<BugFix> fixes = (List<BugFix>) JSON.deserialize(request.Fixes__c, List<BugFix>.class);
                
                // Deploy to specified environment
                DeploymentResult result = deploymentManager.deploy(fixes, environment);
                
                if (result.success) {
                    request.Status__c = 'Deployed';
                    update request;
                    return true;
                } else {
                    request.Status__c = 'Deployment Failed';
                    request.Error_Message__c = result.errorMessage;
                    update request;
                    return false;
                }
            } else {
                request.Status__c = 'Rejected';
                update request;
                return true;
            }
            
        } catch (Exception e) {
            System.debug('Error processing user confirmation: ' + e.getMessage());
            return false;
        }
    }
}
