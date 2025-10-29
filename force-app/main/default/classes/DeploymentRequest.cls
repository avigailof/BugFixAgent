/**
 * @description Data model for deployment requests
 * @author Your Name
 * @version 1.0.0
 */
public class DeploymentRequest {
    public List<BugFix> fixes;
    public String environment;
    public String status;
    public DateTime requestedDate;
    public String requestedBy;
    public String comments;
    
    public DeploymentRequest() {
        this.fixes = new List<BugFix>();
        this.requestedDate = System.now();
        this.status = 'Pending';
    }
}
