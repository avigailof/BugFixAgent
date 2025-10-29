/**
 * @description Test class for BugAnalyzer
 * @author Your Name
 * @version 1.0.0
 */
@IsTest
private class BugAnalyzerTest {
    
    @IsTest
    static void testAnalyzeNullPointerException() {
        Test.startTest();
        
        BugAnalyzer analyzer = new BugAnalyzer();
        
        BugReport bug = new BugReport();
        bug.id = 'test-id';
        bug.name = 'Test Bug';
        bug.description = 'Null pointer exception';
        bug.severity = 'High';
        bug.component = 'TestComponent';
        bug.errorMessage = 'System.NullPointerException: Attempt to de-reference a null object';
        bug.stackTrace = 'TestClass: line 5, column 1';
        
        BugFix fix = analyzer.analyzeAndGenerateFix(bug);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fix, 'Fix should be generated');
        System.assertEquals('NullPointerException', fix.errorType, 'Should identify NullPointerException');
        System.assert(fix.codeFix.contains('null'), 'Should contain null check');
        System.assert(fix.confidence > 70, 'Should have high confidence');
    }
    
    @IsTest
    static void testAnalyzeListException() {
        Test.startTest();
        
        BugAnalyzer analyzer = new BugAnalyzer();
        
        BugReport bug = new BugReport();
        bug.id = 'test-id';
        bug.name = 'Test Bug';
        bug.description = 'List exception';
        bug.severity = 'Medium';
        bug.component = 'TestComponent';
        bug.errorMessage = 'System.ListException: List index out of bounds: 0';
        bug.stackTrace = 'TestClass: line 10, column 1';
        
        BugFix fix = analyzer.analyzeAndGenerateFix(bug);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fix, 'Fix should be generated');
        System.assertEquals('ListException', fix.errorType, 'Should identify ListException');
        System.assert(fix.codeFix.contains('isEmpty'), 'Should contain isEmpty check');
        System.assert(fix.confidence > 70, 'Should have high confidence');
    }
    
    @IsTest
    static void testAnalyzeDmlException() {
        Test.startTest();
        
        BugAnalyzer analyzer = new BugAnalyzer();
        
        BugReport bug = new BugReport();
        bug.id = 'test-id';
        bug.name = 'Test Bug';
        bug.description = 'DML exception';
        bug.severity = 'High';
        bug.component = 'TestComponent';
        bug.errorMessage = 'System.DmlException: Insert failed';
        bug.stackTrace = 'TestClass: line 15, column 1';
        
        BugFix fix = analyzer.analyzeAndGenerateFix(bug);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fix, 'Fix should be generated');
        System.assertEquals('DmlException', fix.errorType, 'Should identify DmlException');
        System.assert(fix.codeFix.contains('try'), 'Should contain try-catch');
        System.assert(fix.confidence > 70, 'Should have high confidence');
    }
    
    @IsTest
    static void testAnalyzeQueryException() {
        Test.startTest();
        
        BugAnalyzer analyzer = new BugAnalyzer();
        
        BugReport bug = new BugReport();
        bug.id = 'test-id';
        bug.name = 'Test Bug';
        bug.description = 'Query exception';
        bug.severity = 'Medium';
        bug.component = 'TestComponent';
        bug.errorMessage = 'System.QueryException: Invalid field';
        bug.stackTrace = 'TestClass: line 20, column 1';
        
        BugFix fix = analyzer.analyzeAndGenerateFix(bug);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fix, 'Fix should be generated');
        System.assertEquals('QueryException', fix.errorType, 'Should identify QueryException');
        System.assert(fix.codeFix.contains('try'), 'Should contain try-catch');
        System.assert(fix.confidence > 70, 'Should have high confidence');
    }
    
    @IsTest
    static void testAnalyzeLimitException() {
        Test.startTest();
        
        BugAnalyzer analyzer = new BugAnalyzer();
        
        BugReport bug = new BugReport();
        bug.id = 'test-id';
        bug.name = 'Test Bug';
        bug.description = 'Limit exception';
        bug.severity = 'High';
        bug.component = 'TestComponent';
        bug.errorMessage = 'System.LimitException: Too many SOQL queries';
        bug.stackTrace = 'TestClass: line 25, column 1';
        
        BugFix fix = analyzer.analyzeAndGenerateFix(bug);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fix, 'Fix should be generated');
        System.assertEquals('LimitException', fix.errorType, 'Should identify LimitException');
        System.assert(fix.codeFix.contains('batchSize'), 'Should contain batch processing');
        System.assert(fix.confidence > 70, 'Should have high confidence');
    }
    
    @IsTest
    static void testAnalyzeUnknownException() {
        Test.startTest();
        
        BugAnalyzer analyzer = new BugAnalyzer();
        
        BugReport bug = new BugReport();
        bug.id = 'test-id';
        bug.name = 'Test Bug';
        bug.description = 'Unknown exception';
        bug.severity = 'Low';
        bug.component = 'TestComponent';
        bug.errorMessage = 'Some unknown error message';
        bug.stackTrace = 'TestClass: line 30, column 1';
        
        BugFix fix = analyzer.analyzeAndGenerateFix(bug);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fix, 'Fix should be generated');
        System.assertEquals('Unknown', fix.errorType, 'Should identify as Unknown');
        System.assert(fix.codeFix.contains('try'), 'Should contain generic try-catch');
        System.assert(fix.confidence < 70, 'Should have lower confidence');
    }
    
    @IsTest
    static void testAnalyzeWithNullValues() {
        Test.startTest();
        
        BugAnalyzer analyzer = new BugAnalyzer();
        
        BugReport bug = new BugReport();
        bug.id = 'test-id';
        bug.name = 'Test Bug';
        bug.description = 'Test with null values';
        bug.severity = 'Medium';
        bug.component = null;
        bug.errorMessage = null;
        bug.stackTrace = null;
        
        BugFix fix = analyzer.analyzeAndGenerateFix(bug);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fix, 'Fix should be generated even with null values');
        System.assertEquals('Unknown', fix.errorType, 'Should identify as Unknown');
        System.assert(fix.confidence < 70, 'Should have lower confidence with null values');
    }
    
    @IsTest
    static void testAnalyzeWithEmptyValues() {
        Test.startTest();
        
        BugAnalyzer analyzer = new BugAnalyzer();
        
        BugReport bug = new BugReport();
        bug.id = 'test-id';
        bug.name = 'Test Bug';
        bug.description = 'Test with empty values';
        bug.severity = 'Low';
        bug.component = '';
        bug.errorMessage = '';
        bug.stackTrace = '';
        
        BugFix fix = analyzer.analyzeAndGenerateFix(bug);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fix, 'Fix should be generated even with empty values');
        System.assertEquals('Unknown', fix.errorType, 'Should identify as Unknown');
        System.assert(fix.confidence < 70, 'Should have lower confidence with empty values');
    }
    
    @IsTest
    static void testAnalyzeWithLongErrorMessage() {
        Test.startTest();
        
        BugAnalyzer analyzer = new BugAnalyzer();
        
        BugReport bug = new BugReport();
        bug.id = 'test-id';
        bug.name = 'Test Bug';
        bug.description = 'Test with long error message';
        bug.severity = 'High';
        bug.component = 'TestComponent';
        bug.errorMessage = 'System.NullPointerException: Attempt to de-reference a null object at line 5 in TestClass. This is a very long error message that contains multiple lines and detailed information about the error that occurred.';
        bug.stackTrace = 'TestClass: line 5, column 1\nAnotherClass: line 10, column 1';
        
        BugFix fix = analyzer.analyzeAndGenerateFix(bug);
        
        Test.stopTest();
        
        System.assertNotEquals(null, fix, 'Fix should be generated');
        System.assertEquals('NullPointerException', fix.errorType, 'Should identify NullPointerException');
        System.assert(fix.confidence > 70, 'Should have high confidence');
    }
}
