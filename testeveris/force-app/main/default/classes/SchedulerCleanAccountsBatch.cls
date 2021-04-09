global class SchedulerCleanAccountsBatch implements Schedulable {
    global void execute(SchedulableContext SC) {
        CleanAccountsBatch b = new CleanAccountsBatch();
        Id JobId = Database.executeBatch(b);
    }
}