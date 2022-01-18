@isTest
public class ContactTriggerHandlerTest {
    @testSetup static void testData(){
        Account acc = new Account();
        acc.Name='Test';
        insert acc;
        Contact con1 = new Contact();
        con1.AccountId = acc.Id;
        con1.LastName ='Test1';
        con1.Amount_X__c=10;
        con1.Type__c='Positive';
        insert con1;
        Contact con2 = new Contact();
        con2.AccountId = acc.Id;
        con2.LastName ='Test2';
        con2.Amount_X__c=10;
        con2.Type__c='Positive';
        insert con2;
        Contact con3 = new Contact();
        con3.AccountId = acc.Id;
        con3.LastName ='Test3';
        con3.Amount_Y__c=20;
        con3.Type__c='Negative';
        insert con3;
        Contact con4 = new Contact();
        con4.AccountId = acc.Id;
        con4.LastName ='Test4';
        con4.Amount_Y__c=20;
        con4.Type__c='Negative';
        insert con4;
    }
    public static testmethod void insertConTest(){
        Account accRec = [SELECT Id,Rollup_Amount_X__c,Rollup_Amount_Y__c,Rollup_Amount__c FROM Account WHERE Name='Test'];
        system.assertEquals(20, accRec.Rollup_Amount_X__c);
        system.assertEquals(40, accRec.Rollup_Amount_Y__c);
        system.assertEquals(60, accRec.Rollup_Amount__c);
    }
    public static testmethod void updateConTest(){
        Contact c1 = [SELECT Id,Amount_X__c FROM Contact WHERE LastName='Test1'];
        c1.Amount_X__c=20;
        update c1;
        Account accRec = [SELECT Id,Rollup_Amount_X__c,Rollup_Amount_Y__c,Rollup_Amount__c FROM Account WHERE Name='Test'];
        system.assertEquals(30, accRec.Rollup_Amount_X__c);
        system.assertEquals(70, accRec.Rollup_Amount__c);
    }
    public static testmethod void deleteConTest(){
        Contact c1 = [SELECT Id,Amount_X__c FROM Contact WHERE LastName='Test1'];
        delete c1;
        Account accRec = [SELECT Id,Rollup_Amount_X__c,Rollup_Amount_Y__c,Rollup_Amount__c FROM Account WHERE Name='Test'];
        system.assertEquals(10, accRec.Rollup_Amount_X__c);
        system.assertEquals(50, accRec.Rollup_Amount__c);
    }
    public static testmethod void unDeleteConTest(){
        Contact c1 = [SELECT Id,Amount_X__c FROM Contact WHERE LastName='Test1'];
        delete c1;
        unDelete c1;
        Account accRec = [SELECT Id,Rollup_Amount_X__c,Rollup_Amount_Y__c,Rollup_Amount__c FROM Account WHERE Name='Test'];
        system.assertEquals(20, accRec.Rollup_Amount_X__c);
        system.assertEquals(60, accRec.Rollup_Amount__c);
    }
}