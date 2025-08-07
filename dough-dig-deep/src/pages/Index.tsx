import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { MoreHorizontal, Settings, DollarSign } from "lucide-react";

const Index = () => {
  const navigate = useNavigate();

  // Mock data - this would come from your state management
  const recentTransactions = [
    {
      id: "1",
      description: "Coffee and breakfast",
      category: "Food",
      amount: 25.50,
      date: "Today"
    },
    {
      id: "2", 
      description: "Bus fare",
      category: "Transport",
      amount: 12.00,
      date: "Yesterday"
    },
    {
      id: "3",
      description: "Grocery shopping",
      category: "Shopping", 
      amount: 85.00,
      date: "2 days ago"
    }
  ];

  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto px-4 py-6">
        {/* Header */}
        <div className="flex justify-between items-center mb-8">
          <div>
            <h1 className="text-3xl font-bold text-foreground">ExpenseTracker</h1>
            <p className="text-muted-foreground">Track your spending</p>
          </div>
          <div className="flex space-x-2">
            <Button 
              variant="ghost" 
              size="icon"
              onClick={() => navigate("/income")}
            >
              <DollarSign className="h-5 w-5" />
            </Button>
            <Button variant="ghost" size="icon">
              <Settings className="h-5 w-5" />
            </Button>
          </div>
        </div>
        
        {/* Summary Cards */}
        <div className="grid grid-cols-2 gap-4 mb-6">
          <Card 
            className="cursor-pointer hover:shadow-lg transition-shadow"
            onClick={() => navigate("/weekly-summary")}
          >
            <CardContent className="p-4">
              <h3 className="text-sm text-muted-foreground mb-1">This Week</h3>
              <p className="text-2xl font-bold text-card-foreground">$142.50</p>
              <p className="text-xs text-green-500 mt-1">↓ 9% from last week</p>
            </CardContent>
          </Card>
          <Card 
            className="cursor-pointer hover:shadow-lg transition-shadow"
            onClick={() => navigate("/monthly-summary")}
          >
            <CardContent className="p-4">
              <h3 className="text-sm text-muted-foreground mb-1">This Month</h3>
              <p className="text-2xl font-bold text-card-foreground">$1,247.85</p>
              <p className="text-xs text-green-500 mt-1">83% of budget</p>
            </CardContent>
          </Card>
        </div>

        {/* Recent Transactions */}
        <Card className="mb-24">
          <CardContent className="p-4">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-semibold text-card-foreground">Recent Transactions</h3>
              <Button 
                variant="ghost" 
                size="sm"
                onClick={() => navigate("/transactions")}
              >
                <MoreHorizontal className="h-4 w-4" />
              </Button>
            </div>
            
            {recentTransactions.length > 0 ? (
              <div className="space-y-3">
                {recentTransactions.map((transaction) => (
                  <div key={transaction.id} className="flex justify-between items-center">
                    <div className="flex-1">
                      <p className="font-medium text-card-foreground">
                        {transaction.description}
                      </p>
                      <div className="flex items-center space-x-2 mt-1">
                        <span className="text-xs bg-secondary text-secondary-foreground px-2 py-1 rounded">
                          {transaction.category}
                        </span>
                        <span className="text-xs text-muted-foreground">
                          {transaction.date}
                        </span>
                      </div>
                    </div>
                    <p className="font-bold text-card-foreground">
                      ${transaction.amount.toFixed(2)}
                    </p>
                  </div>
                ))}
                <Button 
                  variant="ghost" 
                  className="w-full mt-3"
                  onClick={() => navigate("/transactions")}
                >
                  View All Transactions
                </Button>
              </div>
            ) : (
              <div className="text-center py-8">
                <p className="text-muted-foreground">No transactions yet</p>
                <p className="text-sm text-muted-foreground mt-2">Tap the + button to add your first expense</p>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Bottom Navigation */}
        <div className="fixed bottom-0 left-0 right-0 bg-card border-t border-border p-4">
          <div className="flex justify-center">
            <Button 
              className="bg-accent text-accent-foreground w-14 h-14 rounded-full flex items-center justify-center shadow-lg hover:shadow-xl transition-shadow"
              onClick={() => navigate("/add-expense")}
            >
              <span className="text-2xl font-bold">+</span>
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Index;
