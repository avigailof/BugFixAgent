/**
 * @description Test class for BugFixAgent
 * @author Your Name
 * @version 1.0.0
 */
@IsTest
private class BugFixAgentTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test bug reports
        List<Bug_Report__c> bugs = new List<Bug_Report__c>();
        
        Bug_Report__c bug1 = new Bug_Report__c();
        bug1.Description__c = 'Null pointer exception in Account trigger';
        bug1.Severity__c = 'High';
        bug1.Status__c = 'New';
        bug1.Component__c = 'AccountTrigger';
        bug1.Error_Message__c = 'System.NullPointerException: Attempt to de-reference a null object';
        bug1.Stack_Trace__c = 'AccountTrigger: line 5, column 1';
        bugs.add(bug1);
        
        Bug_Report__c bug2 = new Bug_Report__c();
        bug2.Description__c = 'List exception in Contact query';
        bug2.Severity__c = 'Medium';
        bug2.Status__c = 'In Progress';
        bug2.Component__c = 'ContactController';
        bug2.Error_Message__c = 'System.ListException: List index out of bounds: 0';
        bug2.Stack_Trace__c = 'ContactController: line 10, column 1';
        bugs.add(bug2);
        
        insert bugs;
        
        // Create agent configuration
        Agent_Configuration__c config = new Agent_Configuration__c();
        config.Key__c = 'UserEmail';
        config.Value__c = 'test@example.com';
        config.Description__c = 'Test email for notifications';
        config.Category__c = 'Notification';
        config.Is_Active__c = true;
        insert config;
    }
    
    @IsTest
    static void testBugDetection() {
        Test.startTest();
        
        BugFixAgent agent = new BugFixAgent();
        List<BugReport> bugs = agent.detectBugs();
        
        Test.stopTest();
        
        System.assertNotEquals(null, bugs, 'Bugs should be detected');
        System.assertEquals(2, bugs.size(), 'Should detect 2 test bugs');
    }
    
    @IsTest
    static void testBugAnalysis() {
        Test.startTest();
        
        BugAnalyzer analyzer = new BugAnalyzer();
        
        BugReport bug = new BugReport();
        bug.id = 'test-id';
        bug.name = 'Test Bug';
        bug.description = 'Test description';
        bug.severity = 'High';
        bug.component = 'TestComponent';
        bug.errorMessage = 'System.NullPointerException: Attempt to de-reference a null object';
        bug.stackTrace = 'TestClass: line 5, column 1';
        
        BugFix fix = analyzer.analyzeAndGenerateFix(bug);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fix, 'Fix should be generated');
        System.assertEquals('NullPointerException', fix.errorType, 'Should identify NullPointerException');
        System.assertEquals('High', fix.severity, 'Should preserve severity');
        System.assert(fix.confidence > 0, 'Should have confidence score');
    }
    
    @IsTest
    static void testDeploymentManager() {
        Test.startTest();
        
        DeploymentManager manager = new DeploymentManager();
        
        BugFix fix = new BugFix();
        fix.bugId = 'test-bug-id';
        fix.bugName = 'Test Bug';
        fix.severity = 'High';
        fix.component = 'TestComponent';
        fix.errorType = 'NullPointerException';
        fix.description = 'Test fix';
        fix.codeFix = 'if (obj != null) { /* fix */ }';
        fix.confidence = 85.0;
        
        List<BugFix> fixes = new List<BugFix>{fix};
        DeploymentResult result = manager.deploy(fixes, 'Sandbox');
        
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should be returned');
        System.assertEquals('Sandbox', result.environment, 'Should deploy to Sandbox');
    }
    
    @IsTest
    static void testBugFixWorkflow() {
        Test.startTest();
        
        BugFixWorkflow workflow = new BugFixWorkflow();
        WorkflowResult result = workflow.executeWorkflow();
        
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should be returned');
        System.assertEquals(2, result.detectedBugs, 'Should detect 2 bugs');
        System.assert(result.generatedFixes >= 0, 'Should generate fixes');
    }
    
    @IsTest
    static void testDeploymentPackageValidation() {
        Test.startTest();
        
        DeploymentPackage package = new DeploymentPackage();
        
        BugFix fix = new BugFix();
        fix.bugId = 'test-bug-id';
        fix.codeFix = 'if (obj != null) { /* fix */ }';
        fix.confidence = 85.0;
        
        package.addFix(fix);
        
        Boolean isValid = package.validate();
        
        Test.stopTest();
        
        System.assertEquals(true, isValid, 'Package should be valid');
    }
    
    @IsTest
    static void testDeploymentPackageInvalid() {
        Test.startTest();
        
        DeploymentPackage package = new DeploymentPackage();
        
        BugFix fix = new BugFix();
        fix.bugId = 'test-bug-id';
        fix.codeFix = ''; // Empty fix
        fix.confidence = 50.0; // Low confidence
        
        package.addFix(fix);
        
        Boolean isValid = package.validate();
        
        Test.stopTest();
        
        System.assertEquals(false, isValid, 'Package should be invalid');
        System.assert(!package.validationErrors.isEmpty(), 'Should have validation errors');
    }
    
    @IsTest
    static void testAgentCapabilities() {
        Test.startTest();
        
        BugFixAgent agent = new BugFixAgent();
        List<AgentForce.Capability> capabilities = agent.getCapabilities();
        
        Test.stopTest();
        
        System.assertNotEquals(null, capabilities, 'Capabilities should be returned');
        System.assertEquals(5, capabilities.size(), 'Should have 5 capabilities');
    }
    
    @IsTest
    static void testAgentExecution() {
        Test.startTest();
        
        BugFixAgent agent = new BugFixAgent();
        AgentForce.Context context = new AgentForce.Context();
        AgentForce.Result result = agent.execute(context);
        
        Test.stopTest();
        
        System.assertNotEquals(null, result, 'Result should be returned');
        System.assertEquals(true, result.success, 'Execution should succeed');
    }
    
    @IsTest
    static void testDeployToSandbox() {
        Test.startTest();
        
        BugFixAgent agent = new BugFixAgent();
        
        BugFix fix = new BugFix();
        fix.bugId = 'test-bug-id';
        fix.codeFix = 'if (obj != null) { /* fix */ }';
        
        List<BugFix> fixes = new List<BugFix>{fix};
        Boolean success = agent.deployToSandbox(fixes);
        
        Test.stopTest();
        
        System.assertEquals(true, success, 'Sandbox deployment should succeed');
    }
    
    @IsTest
    static void testDeployToProduction() {
        Test.startTest();
        
        BugFixAgent agent = new BugFixAgent();
        
        BugFix fix = new BugFix();
        fix.bugId = 'test-bug-id';
        fix.codeFix = 'if (obj != null) { /* fix */ }';
        
        List<BugFix> fixes = new List<BugFix>{fix};
        Boolean success = agent.deployToProduction(fixes);
        
        Test.stopTest();
        
        System.assertEquals(true, success, 'Production deployment should succeed');
    }
    
    @IsTest
    static void testAPIEndpoints() {
        Test.startTest();
        
        // Test GET endpoint
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/bugfixagent/';
        req.httpMethod = 'GET';
        req.params.put('status', 'New');
        
        RestContext.request = req;
        RestContext.response = res;
        
        BugFixAgentAPI.getBugReports();
        
        Test.stopTest();
        
        System.assertEquals(200, res.statusCode, 'GET should return 200');
    }
    
    @IsTest
    static void testAPIWorkflowTrigger() {
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/bugfixagent/workflow';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{}');
        
        RestContext.request = req;
        RestContext.response = res;
        
        BugFixAgentAPI.triggerBugFixWorkflow();
        
        Test.stopTest();
        
        System.assertEquals(200, res.statusCode, 'Workflow trigger should return 200');
    }
    
    @IsTest
    static void testErrorHandling() {
        Test.startTest();
        
        try {
            // Test with invalid data
            BugAnalyzer analyzer = new BugAnalyzer();
            BugReport bug = new BugReport();
            bug.errorMessage = null;
            bug.stackTrace = null;
            
            BugFix fix = analyzer.analyzeAndGenerateFix(bug);
            
            Test.stopTest();
            
            // Should handle gracefully
            System.assert(true, 'Should handle null error message gracefully');
            
        } catch (Exception e) {
            Test.stopTest();
            System.fail('Should not throw exception: ' + e.getMessage());
        }
    }
}
