//+------------------------------------------------------------------+
//|                                                 SymbolSearch.mqh |
//|                                 Copyright 2017, Keisuke Iwabuchi |
//|                                        https://order-button.com/ |
//+------------------------------------------------------------------+


#ifndef _LOAD_MODULE_SYMBOL_SEARCH
#define _LOAD_MODULE_SYMBOL_SEARCH


/** Surely to get the symbol. */
class SymbolSearch
{
   public:
      static string getSymbolInMarket(const string currency1, 
                                      const string currency2 = "");
      static string getSymbolInAll(const string currency1, 
                                   const string currency2 = "");
   
   private:
      static string getSymbol(      bool   selected, 
                              const string currency1, 
                              const string currency2 = "");
};


/**
 * Acquire the currency pair name including currency1 from MarketWatch.
 * If currency2 is specified, 
 * acquire the currency pair name including currency1 and currency2.
 * If it does not exist in MarketWatch but exist in all symbols,
 * add name to MarketWatch and return the currency pair name.
 *
 * @param const string currency1  Symbol name.
 * @param const string currency2  Symbol name.
 *
 * @return string  Applicable symbol name. 
 *                 If there is no applicable symbol name,
 *                 it returns an empty string.
 */
static string SymbolSearch::getSymbolInMarket(const string currency1, 
                                              const string currency2 = "")
{
   string symbol, add;
   
   /** Get symbol name from MarketWatch. */
   symbol = SymbolSearch::getSymbol(true, currency1, currency2);
   if(StringLen(symbol) > 0) return(symbol);

   /** Get symbol name from all. */
   add = SymbolSearch::getSymbol(false, currency1, currency2);
   
   /** If symbol exists, add symbol to MarketWatch. */
   if(StringLen(add) > 0) {
      SymbolSelect(add, true);
      
      /**
       * There is a time lag before being updated.
       * As a workaround, sleep for 1 second.
       */
      Sleep(1000);
   }

   return(add);
}


/**
 * Acquire the currency pair name including currency1 from all.
 * If currency2 is specified, 
 * acquire the currency pair name including currency1 and currency2.
 *
 * @param const string currency1  Symbol name.
 * @param const string currency2  Symbol name.
 *
 * @return string  Applicable symbol name. 
 *                 If there is no applicable symbol name,
 *                 it returns an empty string.
 */
static string SymbolSearch::getSymbolInAll(const string currency1, 
                                           const string currency2 = "")
{
   return(SymbolSearch::getSymbol(false, currency1, currency2));
}


/**
 * Acquire the currency pair name including currency1.
 * If currency2 is specified, 
 * acquire the currency pair name including currency1 and currency2.
 *
 * @param bool selected  True - only symbols in MarketWatch.
 * @param const string currency1  Symbol name.
 * @param const string currency2  Symbol name.
 *
 * @return string  Applicable symbol name. 
 *                 If there is no applicable symbol name,
 *                 it returns an empty string.
 */
static string SymbolSearch::getSymbol(      bool   selected,
                                      const string currency1, 
                                      const string currency2 = "")
{
   string symbol = "";
   
   for(int i = 0; i < SymbolsTotal(selected); i++) {
      symbol = SymbolName(i, selected);
      if(StringFind(symbol, currency1) == -1) continue;
      if(StringLen(currency2) > 0) {
         if(StringFind(symbol, currency2) == -1) continue;
      }
      
      return(symbol);
   }
   
   return("");
}


#endif
