/**
 * @description REST API integration for Salesforce DevOps platform
 * @author Your Name
 * @version 1.0.0
 */
@RestResource(urlMapping='/bugfixagent/*')
global with sharing class BugFixAgentAPI {
    
    /**
     * @description GET endpoint to retrieve bug reports
     */
    @HttpGet
    global static void getBugReports() {
        try {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            
            // Parse query parameters
            String status = req.params.get('status');
            String severity = req.params.get('severity');
            Integer limit = Integer.valueOf(req.params.get('limit'));
            
            if (limit == null) limit = 50;
            
            // Query bug reports
            String soql = 'SELECT Id, Name, Description__c, Severity__c, Status__c, ' +
                         'Component__c, Error_Message__c, Stack_Trace__c, ' +
                         'CreatedDate, LastModifiedDate FROM Bug_Report__c';
            
            List<String> conditions = new List<String>();
            if (String.isNotBlank(status)) {
                conditions.add('Status__c = \'' + String.escapeSingleQuotes(status) + '\'');
            }
            if (String.isNotBlank(severity)) {
                conditions.add('Severity__c = \'' + String.escapeSingleQuotes(severity) + '\'');
            }
            
            if (!conditions.isEmpty()) {
                soql += ' WHERE ' + String.join(conditions, ' AND ');
            }
            
            soql += ' ORDER BY Severity__c DESC, CreatedDate ASC LIMIT ' + limit;
            
            List<Bug_Report__c> bugs = Database.query(soql);
            
            // Convert to response format
            List<Map<String, Object>> response = new List<Map<String, Object>>();
            for (Bug_Report__c bug : bugs) {
                Map<String, Object> bugMap = new Map<String, Object>();
                bugMap.put('id', bug.Id);
                bugMap.put('name', bug.Name);
                bugMap.put('description', bug.Description__c);
                bugMap.put('severity', bug.Severity__c);
                bugMap.put('status', bug.Status__c);
                bugMap.put('component', bug.Component__c);
                bugMap.put('errorMessage', bug.Error_Message__c);
                bugMap.put('stackTrace', bug.Stack_Trace__c);
                bugMap.put('createdDate', bug.CreatedDate);
                bugMap.put('lastModifiedDate', bug.LastModifiedDate);
                
                response.add(bugMap);
            }
            
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            
        } catch (Exception e) {
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        }
    }
    
    /**
     * @description POST endpoint to create a new bug report
     */
    @HttpPost
    global static void createBugReport() {
        try {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            
            // Parse request body
            Map<String, Object> requestData = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
            
            // Create bug report
            Bug_Report__c bug = new Bug_Report__c();
            bug.Description__c = (String) requestData.get('description');
            bug.Severity__c = (String) requestData.get('severity');
            bug.Status__c = 'New';
            bug.Component__c = (String) requestData.get('component');
            bug.Error_Message__c = (String) requestData.get('errorMessage');
            bug.Stack_Trace__c = (String) requestData.get('stackTrace');
            
            insert bug;
            
            // Return created bug
            Map<String, Object> response = new Map<String, Object>();
            response.put('id', bug.Id);
            response.put('name', bug.Name);
            response.put('status', 'created');
            
            res.statusCode = 201;
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            
        } catch (Exception e) {
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        }
    }
    
    /**
     * @description PUT endpoint to update bug report status
     */
    @HttpPut
    global static void updateBugReport() {
        try {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            
            // Parse request body
            Map<String, Object> requestData = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
            
            String bugId = (String) requestData.get('id');
            String status = (String) requestData.get('status');
            
            if (String.isBlank(bugId) || String.isBlank(status)) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('{"error": "Missing required fields: id and status"}');
                return;
            }
            
            // Update bug report
            Bug_Report__c bug = new Bug_Report__c();
            bug.Id = bugId;
            bug.Status__c = status;
            
            update bug;
            
            // Return success response
            Map<String, Object> response = new Map<String, Object>();
            response.put('id', bugId);
            response.put('status', 'updated');
            
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            
        } catch (Exception e) {
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        }
    }
    
    /**
     * @description POST endpoint to trigger bug fixing workflow
     */
    @HttpPost
    global static void triggerBugFixWorkflow() {
        try {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            
            // Execute bug fixing workflow
            BugFixWorkflow workflow = new BugFixWorkflow();
            WorkflowResult result = workflow.executeWorkflow();
            
            // Return workflow result
            Map<String, Object> response = new Map<String, Object>();
            response.put('success', result.success);
            response.put('status', result.status);
            response.put('detectedBugs', result.detectedBugs);
            response.put('generatedFixes', result.generatedFixes);
            response.put('duration', result.duration);
            
            if (!result.success) {
                response.put('error', result.errorMessage);
            }
            
            res.statusCode = result.success ? 200 : 500;
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            
        } catch (Exception e) {
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        }
    }
    
    /**
     * @description POST endpoint to process deployment confirmation
     */
    @HttpPost
    global static void processDeploymentConfirmation() {
        try {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            
            // Parse request body
            Map<String, Object> requestData = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
            
            String requestId = (String) requestData.get('requestId');
            Boolean confirmed = (Boolean) requestData.get('confirmed');
            String environment = (String) requestData.get('environment');
            
            if (String.isBlank(requestId) || confirmed == null || String.isBlank(environment)) {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('{"error": "Missing required fields: requestId, confirmed, and environment"}');
                return;
            }
            
            // Process confirmation
            BugFixWorkflow workflow = new BugFixWorkflow();
            Boolean success = workflow.processUserConfirmation(requestId, confirmed, environment);
            
            // Return result
            Map<String, Object> response = new Map<String, Object>();
            response.put('success', success);
            response.put('requestId', requestId);
            response.put('confirmed', confirmed);
            response.put('environment', environment);
            
            res.statusCode = success ? 200 : 500;
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            
        } catch (Exception e) {
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        }
    }
    
    /**
     * @description GET endpoint to retrieve deployment history
     */
    @HttpGet
    global static void getDeploymentHistory() {
        try {
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            
            String environment = req.params.get('environment');
            Integer limit = Integer.valueOf(req.params.get('limit'));
            
            if (limit == null) limit = 50;
            
            // Query deployment history
            String soql = 'SELECT Id, Environment__c, Status__c, Deployed_Fixes__c, ' +
                         'Deployment_Date__c, Error_Message__c FROM Deployment_History__c';
            
            if (String.isNotBlank(environment)) {
                soql += ' WHERE Environment__c = \'' + String.escapeSingleQuotes(environment) + '\'';
            }
            
            soql += ' ORDER BY Deployment_Date__c DESC LIMIT ' + limit;
            
            List<Deployment_History__c> history = Database.query(soql);
            
            // Convert to response format
            List<Map<String, Object>> response = new List<Map<String, Object>>();
            for (Deployment_History__c record : history) {
                Map<String, Object> historyMap = new Map<String, Object>();
                historyMap.put('id', record.Id);
                historyMap.put('environment', record.Environment__c);
                historyMap.put('status', record.Status__c);
                historyMap.put('deployedFixes', record.Deployed_Fixes__c);
                historyMap.put('deploymentDate', record.Deployment_Date__c);
                historyMap.put('errorMessage', record.Error_Message__c);
                
                response.add(historyMap);
            }
            
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(response));
            
        } catch (Exception e) {
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        }
    }
}
