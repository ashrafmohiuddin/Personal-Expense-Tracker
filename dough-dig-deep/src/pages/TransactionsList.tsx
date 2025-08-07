import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Edit, Trash2 } from "lucide-react";

interface Transaction {
  id: string;
  amount: number;
  description: string;
  category: string;
  trip?: string;
  date: Date;
}

const TransactionsList = () => {
  const navigate = useNavigate();
  
  // Mock data - this would come from your state management
  const [transactions] = useState<Transaction[]>([
    {
      id: "1",
      amount: 25.50,
      description: "Coffee and breakfast",
      category: "Food",
      trip: "Personal",
      date: new Date("2024-01-15")
    },
    {
      id: "2",
      amount: 12.00,
      description: "Bus fare",
      category: "Transport",
      date: new Date("2024-01-14")
    },
    {
      id: "3",
      amount: 85.00,
      description: "Grocery shopping",
      category: "Shopping",
      trip: "Personal",
      date: new Date("2024-01-13")
    }
  ]);

  const [swipedCard, setSwipedCard] = useState<string | null>(null);
  const [touchStart, setTouchStart] = useState<number | null>(null);
  const [touchEnd, setTouchEnd] = useState<number | null>(null);

  const minSwipeDistance = 50;

  const onTouchStart = (e: React.TouchEvent) => {
    setTouchEnd(null);
    setTouchStart(e.targetTouches[0].clientX);
  };

  const onTouchMove = (e: React.TouchEvent) => {
    setTouchEnd(e.targetTouches[0].clientX);
  };

  const onTouchEnd = (transactionId: string) => {
    if (!touchStart || !touchEnd) return;
    
    const distance = touchStart - touchEnd;
    const isLeftSwipe = distance > minSwipeDistance;
    const isRightSwipe = distance < -minSwipeDistance;

    if (isLeftSwipe) {
      setSwipedCard(transactionId);
    } else if (isRightSwipe) {
      setSwipedCard(null);
    }
  };

  const handleEdit = (transaction: Transaction) => {
    console.log("Edit transaction:", transaction);
    // Navigate to edit screen or open modal
  };

  const handleDelete = (transactionId: string) => {
    console.log("Delete transaction:", transactionId);
    // Delete transaction logic
  };

  const formatDate = (date: Date) => {
    return date.toLocaleDateString("en-US", { 
      month: "short", 
      day: "numeric",
      year: "numeric"
    });
  };

  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto px-4 py-6">
        {/* Header */}
        <div className="flex items-center mb-6">
          <Button 
            variant="ghost" 
            size="icon" 
            onClick={() => navigate("/")}
            className="mr-3"
          >
            <ArrowLeft className="h-5 w-5" />
          </Button>
          <h1 className="text-2xl font-bold text-foreground">All Transactions</h1>
        </div>

        {/* Transactions List */}
        <div className="space-y-3">
          {transactions.map((transaction) => (
            <div key={transaction.id} className="relative">
              {/* Swipe Actions Background */}
              {swipedCard === transaction.id && (
                <div className="absolute inset-0 bg-card rounded-lg flex items-center justify-end pr-4 space-x-2">
                  <Button
                    size="icon"
                    variant="secondary"
                    onClick={() => handleEdit(transaction)}
                  >
                    <Edit className="h-4 w-4" />
                  </Button>
                  <Button
                    size="icon"
                    variant="destructive"
                    onClick={() => handleDelete(transaction.id)}
                  >
                    <Trash2 className="h-4 w-4" />
                  </Button>
                </div>
              )}
              
              {/* Transaction Card */}
              <div
                className={`bg-card border border-border rounded-lg p-4 cursor-pointer transition-transform duration-200 ${
                  swipedCard === transaction.id ? 'transform -translate-x-20' : ''
                }`}
                onTouchStart={onTouchStart}
                onTouchMove={onTouchMove}
                onTouchEnd={() => onTouchEnd(transaction.id)}
              >
                <div className="flex justify-between items-start">
                  <div className="flex-1">
                    <h3 className="font-semibold text-card-foreground">
                      {transaction.description}
                    </h3>
                    <div className="flex items-center space-x-2 mt-1">
                      <span className="text-sm bg-secondary text-secondary-foreground px-2 py-1 rounded">
                        {transaction.category}
                      </span>
                      {transaction.trip && (
                        <span className="text-sm bg-accent text-accent-foreground px-2 py-1 rounded">
                          {transaction.trip}
                        </span>
                      )}
                    </div>
                    <p className="text-sm text-muted-foreground mt-1">
                      {formatDate(transaction.date)}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="text-lg font-bold text-card-foreground">
                      ${transaction.amount.toFixed(2)}
                    </p>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>

        {transactions.length === 0 && (
          <div className="text-center py-12">
            <p className="text-muted-foreground">No transactions yet</p>
            <Button 
              onClick={() => navigate("/add-expense")} 
              className="mt-4"
            >
              Add Your First Expense
            </Button>
          </div>
        )}
      </div>
    </div>
  );
};

export default TransactionsList;