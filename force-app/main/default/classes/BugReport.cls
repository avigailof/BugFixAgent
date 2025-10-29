/**
 * @description Data model for bug reports
 * @author Your Name
 * @version 1.0.0
 */
public class BugReport {
    public String id;
    public String name;
    public String description;
    public String severity;
    public String status;
    public String component;
    public String errorMessage;
    public String stackTrace;
    public DateTime createdDate;
    public DateTime lastModifiedDate;
    
    public BugReport() {
        this.createdDate = System.now();
        this.lastModifiedDate = System.now();
    }
}
