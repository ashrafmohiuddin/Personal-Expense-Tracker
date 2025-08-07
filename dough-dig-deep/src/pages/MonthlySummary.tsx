import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { ArrowLeft, TrendingUp, TrendingDown, Target, Calendar } from "lucide-react";

const MonthlySummary = () => {
  const navigate = useNavigate();

  // Mock data - this would come from your state management
  const monthlyData = {
    totalSpent: 1247.85,
    budget: 1500.00,
    dailyAverage: 41.60,
    topCategory: "Food",
    previousMonth: 1156.32,
    daysLeft: 8,
    suggestions: [
      "You're on track to stay within budget this month!",
      "Food expenses increased by 15% from last month. Consider meal prep to save money.",
      "You have $252.15 left for the remaining 8 days - that's $31.52 per day.",
      "Weekend entertainment spending spiked. Set a weekend limit to stay on track."
    ]
  };

  const weeklyTrend = [
    { week: "Week 1", amount: 287.50 },
    { week: "Week 2", amount: 342.20 },
    { week: "Week 3", amount: 475.65 },
    { week: "Week 4", amount: 142.50 }
  ];

  const categoryBreakdown = [
    { name: "Food", amount: 456.30, percentage: 37 },
    { name: "Shopping", amount: 298.50, percentage: 24 },
    { name: "Entertainment", amount: 187.25, percentage: 15 },
    { name: "Transport", amount: 156.80, percentage: 13 },
    { name: "Bills", amount: 149.00, percentage: 11 }
  ];

  const budgetUsed = (monthlyData.totalSpent / monthlyData.budget) * 100;
  const isOverBudget = budgetUsed > 100;
  const remaining = monthlyData.budget - monthlyData.totalSpent;

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
          <h1 className="text-2xl font-bold text-foreground">Monthly Summary</h1>
        </div>

        {/* Budget Overview */}
        <Card className="mb-6">
          <CardHeader className="text-center">
            <CardTitle className="text-3xl font-bold text-card-foreground">
              ${monthlyData.totalSpent.toFixed(2)}
            </CardTitle>
            <p className="text-muted-foreground">
              of ${monthlyData.budget.toFixed(2)} budget
            </p>
          </CardHeader>
          <CardContent>
            <div className="w-full bg-secondary rounded-full h-3 mb-4">
              <div 
                className={`h-3 rounded-full transition-all duration-300 ${
                  isOverBudget ? 'bg-destructive' : 'bg-primary'
                }`}
                style={{ width: `${Math.min(budgetUsed, 100)}%` }}
              ></div>
            </div>
            <div className="flex justify-between items-center">
              <span className="text-sm text-muted-foreground">
                {budgetUsed.toFixed(1)}% used
              </span>
              <span className={`text-sm font-medium ${
                remaining >= 0 ? 'text-green-500' : 'text-destructive'
              }`}>
                ${Math.abs(remaining).toFixed(2)} {remaining >= 0 ? 'remaining' : 'over'}
              </span>
            </div>
          </CardContent>
        </Card>

        {/* Stats Grid */}
        <div className="grid grid-cols-2 gap-4 mb-6">
          <Card>
            <CardContent className="p-4 text-center">
              <Calendar className="h-6 w-6 mx-auto mb-2 text-primary" />
              <p className="text-2xl font-bold text-card-foreground">
                {monthlyData.daysLeft}
              </p>
              <p className="text-sm text-muted-foreground">Days Left</p>
            </CardContent>
          </Card>
          <Card>
            <CardContent className="p-4 text-center">
              <Target className="h-6 w-6 mx-auto mb-2 text-primary" />
              <p className="text-2xl font-bold text-card-foreground">
                ${(remaining / monthlyData.daysLeft).toFixed(2)}
              </p>
              <p className="text-sm text-muted-foreground">Daily Budget Left</p>
            </CardContent>
          </Card>
        </div>

        {/* Weekly Trend */}
        <Card className="mb-6">
          <CardHeader>
            <CardTitle>Weekly Spending Trend</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {weeklyTrend.map((week) => (
                <div key={week.week} className="flex items-center justify-between">
                  <span className="text-card-foreground">{week.week}</span>
                  <div className="flex items-center space-x-2">
                    <div className="w-24 bg-secondary rounded-full h-2">
                      <div 
                        className="h-2 bg-primary rounded-full"
                        style={{ width: `${(week.amount / 500) * 100}%` }}
                      ></div>
                    </div>
                    <span className="text-card-foreground font-medium w-16 text-right">
                      ${week.amount.toFixed(0)}
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Category Breakdown */}
        <Card className="mb-6">
          <CardHeader>
            <CardTitle>Top Categories</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {categoryBreakdown.map((category, index) => (
                <div key={category.name} className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <div className={`w-3 h-3 rounded-full ${
                      index === 0 ? 'bg-primary' : 
                      index === 1 ? 'bg-secondary' : 'bg-accent'
                    }`}></div>
                    <span className="text-card-foreground">{category.name}</span>
                  </div>
                  <div className="text-right">
                    <p className="font-semibold text-card-foreground">
                      ${category.amount.toFixed(2)}
                    </p>
                    <p className="text-sm text-muted-foreground">
                      {category.percentage}%
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* AI Suggestions */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center space-x-2">
              <TrendingUp className="h-5 w-5" />
              <span>Monthly Insights</span>
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {monthlyData.suggestions.map((suggestion, index) => (
                <div key={index} className="flex items-start space-x-3">
                  <div className="w-2 h-2 bg-accent rounded-full mt-2"></div>
                  <p className="text-card-foreground text-sm">{suggestion}</p>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default MonthlySummary;