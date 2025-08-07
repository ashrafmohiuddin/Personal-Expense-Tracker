import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { ArrowLeft, TrendingUp, TrendingDown, AlertCircle } from "lucide-react";

const WeeklySummary = () => {
  const navigate = useNavigate();

  // Mock data - this would come from your state management
  const weeklyData = {
    totalSpent: 142.50,
    dailyAverage: 20.36,
    topCategory: "Food",
    topCategoryAmount: 65.50,
    previousWeek: 156.75,
    suggestions: [
      "You spent 9% less than last week. Great job!",
      "Food expenses are 45% of your weekly spending. Consider meal planning.",
      "Weekend spending was higher. Try setting a weekend budget."
    ]
  };

  const categoryBreakdown = [
    { name: "Food", amount: 65.50, percentage: 46 },
    { name: "Transport", amount: 32.00, percentage: 22 },
    { name: "Entertainment", amount: 28.00, percentage: 20 },
    { name: "Shopping", amount: 17.00, percentage: 12 }
  ];

  const isImprovement = weeklyData.totalSpent < weeklyData.previousWeek;

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
          <h1 className="text-2xl font-bold text-foreground">Weekly Summary</h1>
        </div>

        {/* Total Spent Card */}
        <Card className="mb-6">
          <CardHeader className="text-center">
            <CardTitle className="text-3xl font-bold text-card-foreground">
              ${weeklyData.totalSpent.toFixed(2)}
            </CardTitle>
            <p className="text-muted-foreground">Total spent this week</p>
          </CardHeader>
          <CardContent className="text-center">
            <div className="flex items-center justify-center space-x-2">
              {isImprovement ? (
                <TrendingDown className="h-4 w-4 text-green-500" />
              ) : (
                <TrendingUp className="h-4 w-4 text-red-500" />
              )}
              <span className={`text-sm ${isImprovement ? 'text-green-500' : 'text-red-500'}`}>
                {Math.abs(((weeklyData.totalSpent - weeklyData.previousWeek) / weeklyData.previousWeek) * 100).toFixed(1)}%
                {isImprovement ? ' less' : ' more'} than last week
              </span>
            </div>
          </CardContent>
        </Card>

        {/* Stats Grid */}
        <div className="grid grid-cols-2 gap-4 mb-6">
          <Card>
            <CardContent className="p-4 text-center">
              <p className="text-2xl font-bold text-card-foreground">
                ${weeklyData.dailyAverage.toFixed(2)}
              </p>
              <p className="text-sm text-muted-foreground">Daily Average</p>
            </CardContent>
          </Card>
          <Card>
            <CardContent className="p-4 text-center">
              <p className="text-2xl font-bold text-card-foreground">
                {weeklyData.topCategory}
              </p>
              <p className="text-sm text-muted-foreground">Top Category</p>
            </CardContent>
          </Card>
        </div>

        {/* Category Breakdown */}
        <Card className="mb-6">
          <CardHeader>
            <CardTitle>Category Breakdown</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {categoryBreakdown.map((category) => (
                <div key={category.name} className="flex items-center justify-between">
                  <div className="flex items-center space-x-3">
                    <div className="w-3 h-3 bg-primary rounded-full"></div>
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
              <AlertCircle className="h-5 w-5" />
              <span>Smart Insights</span>
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-3">
              {weeklyData.suggestions.map((suggestion, index) => (
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

export default WeeklySummary;