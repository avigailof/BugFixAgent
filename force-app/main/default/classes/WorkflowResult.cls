/**
 * @description Data model for workflow results
 * @author Your Name
 * @version 1.0.0
 */
public class WorkflowResult {
    public DateTime startTime;
    public DateTime endTime;
    public Long duration;
    public Boolean success;
    public String status;
    public String errorMessage;
    public Integer detectedBugs;
    public Integer generatedFixes;
    public List<String> warnings;
    
    public WorkflowResult() {
        this.success = false;
        this.detectedBugs = 0;
        this.generatedFixes = 0;
        this.warnings = new List<String>();
    }
}
