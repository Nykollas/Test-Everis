@IsTest(seeAllData=true)
public class CleanAccountBatchTest {
    @isTest
    public static void  test(){
        CleanAccountsBatch b = new CleanAccountsBatch();
        Id JobId = Database.executeBatch(b);
    }
}