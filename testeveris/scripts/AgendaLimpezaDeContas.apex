//Agendando execução quatro vezes por dia

SchedulerCleanAccountsBatch cleanAcc = new SchedulerCleanAccountsBatch();

String sch1 = '0 0 0 ? * * *';
String jobID1 = System.schedule('Limpeza contas 1', sch1, cleanAcc);

String sch2= '0 0 6 ? * * *';
String jobID2 = System.schedule('Limpeza contas 2', sch2, cleanAcc);

String sch3 = '0 0 12 ? * * *';
String jobID3 = System.schedule('Limpeza contas 3', sch3, cleanAcc);

String sch4 = '0 0 18 ? * * *';
String jobID4 = System.schedule('Limpeza contas 4', sch4, cleanAcc);