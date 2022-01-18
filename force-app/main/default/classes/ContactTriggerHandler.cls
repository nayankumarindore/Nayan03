public class ContactTriggerHandler {
    static set<id> accIdSet = new Set<Id>();
    Static List<Account> accList = new List<Account>();
    
    public static void conInsert(List<Contact>conList){
        for(Contact con: conList){
            if(!string.isBlank(con.AccountId)){
                accIdSet.add(con.AccountId);
            }
        }
        aggregateResults();
    }
    
    public static void conUpdate(List<Contact>newConList,Map<Id,Contact>oldConMap){
        for(contact con: newConList){
            if(!String.isBlank(con.AccountId)){
                accIdSet.add(con.AccountId);
                if(oldConMap.get(con.Id).AccountId != con.AccountId){
                    accIdSet.add(con.AccountId);
                }
            }
        }
        aggregateResults();
    }
    
    public static void conDelete(List<Contact> conList){
        for(Contact con: conList){
            if(!string.isBlank(con.AccountId)){
                accIdSet.add(con.AccountId);
            }
        }
        aggregateResults();
    }
    public static void conUndelete(List<Contact>conList){
        for(Contact con: conList){
            if(!string.isBlank(con.AccountId)){
                accIdSet.add(con.AccountId);
            }
        }
        aggregateResults();
    }
    
    public static void aggregateResults(){   
        Map<Id,Account> accMap = new Map<Id,Account>();
        AggregateResult[] groupedResults = [SELECT SUM(Amount_X__c) sumOfAmountX, SUM(Amount_Y__c) sumOfAmountY, 
                                            AccountId, Type__c
                                            FROM Contact
                                            WHERE AccountId IN : accIdSet
                                            GROUP BY AccountId, Type__c
                                            ORDER BY AccountId];
        for(AggregateResult ar:groupedResults){
            Id accId = (ID)ar.get('AccountId');
            String conType = (String)ar.get('Type__c');
            double amountX, amountY;
            Account acc = accMap.get(accId);
            if( acc == null ) {
                acc = new Account( Id = accId );
            }
            if(conType=='Positive'){
                amountX = (double)ar.get('sumOfAmountX');
                if(amountX==null){
                    acc.Rollup_Amount_X__c=0;
                }
                else{
                    acc.Rollup_Amount_X__c = amountX;
                }
                if(acc.Rollup_Amount_Y__c==null){
                    acc.Rollup_Amount_Y__c=0;
                }
                else{
                    acc.Rollup_Amount_Y__c=acc.Rollup_Amount_Y__c;
                }
            }
            else if(conType=='Negative'){
                amountY = (double)ar.get('sumOfAmountY');
                if(amountY==null){
                    acc.Rollup_Amount_Y__c = 0;
                }
                else{
                    acc.Rollup_Amount_Y__c = amountY;
                }
                if(acc.Rollup_Amount_X__c==null){
                    acc.Rollup_Amount_X__c=0;
                }
                else{
                    acc.Rollup_Amount_X__c=acc.Rollup_Amount_X__c;
                }
            }
            else{
                acc.Rollup_Amount_X__c = 0;
                acc.Rollup_Amount_Y__c = 0;
            }
            acc.Rollup_Amount__c = acc.Rollup_Amount_X__c + acc.Rollup_Amount_Y__c;
            accMap.put(acc.Id,acc);
        }
        
        try{
            if(accMap.size()>0){
                update accMap.values();
            }
        }Catch(Exception ex){
            system.debug('ex=='+ex.getMessage());
            system.debug('ex=='+ex.getStackTraceString());
        }
    }
}