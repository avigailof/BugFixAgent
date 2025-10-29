/**
 * @description Custom exception for deployment errors
 * @author Your Name
 * @version 1.0.0
 */
public class DeploymentException extends Exception {
    
    public DeploymentException(String message) {
        this(message, null);
    }
    
    public DeploymentException(String message, Exception cause) {
        super(message, cause);
    }
}
