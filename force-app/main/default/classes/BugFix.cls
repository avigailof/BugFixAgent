/**
 * @description Data model for bug fixes
 * @author Your Name
 * @version 1.0.0
 */
public class BugFix {
    public String bugId;
    public String bugName;
    public String severity;
    public String component;
    public String errorType;
    public String description;
    public String codeFix;
    public DateTime createdDate;
    public String status;
    public Decimal confidence;
    
    public BugFix() {
        this.createdDate = System.now();
        this.status = 'Generated';
        this.confidence = 0.0;
    }
}
