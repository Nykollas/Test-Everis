@isTest
public class SchedulerCleanAccountsBatchTest {
  @isTest
  public static void test() {
    Test.startTest();
    //Agendando executando scheduler para a 00:00 de cada dia
    String jobId = System.schedule(
      'SchedulerCleanAccountsBatch',
      '0 0 0 ? * * *',
      new SchedulerCleanAccountsBatch()
    );
    //Recebendo informações do agendamento
    CronTrigger ct = [
      SELECT Id, CronExpression, TimesTriggered, NextFireTime
      FROM CronTrigger
      WHERE id = :jobId
    ];

    //Validando se as informações correspondem ao que foi agendado
    System.assertEquals('0 0 0 ? * * *', ct.CronExpression);

    System.assertEquals(0, ct.TimesTriggered);


    Test.stopTest();
  }	
}