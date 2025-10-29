/**
 * @description Data model for deployment results
 * @author Your Name
 * @version 1.0.0
 */
public class DeploymentResult {
    public String environment;
    public DateTime deploymentDate;
    public Boolean success;
    public String message;
    public String errorMessage;
    public Integer deployedFixes;
    public List<String> warnings;
    
    public DeploymentResult() {
        this.success = false;
        this.deployedFixes = 0;
        this.warnings = new List<String>();
    }
}
