import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { ArrowLeft, Plus, Edit, Trash2 } from "lucide-react";

interface IncomeItem {
  id: string;
  source: string;
  amount: number;
  frequency: "monthly" | "weekly" | "yearly";
  type: "salary" | "freelance" | "investment" | "other";
}

const Income = () => {
  const navigate = useNavigate();
  const [showAddForm, setShowAddForm] = useState(false);
  const [source, setSource] = useState("");
  const [amount, setAmount] = useState("");
  const [frequency, setFrequency] = useState<"monthly" | "weekly" | "yearly">("monthly");
  const [type, setType] = useState<"salary" | "freelance" | "investment" | "other">("salary");

  // Mock data - this would come from your state management
  const [incomeItems, setIncomeItems] = useState<IncomeItem[]>([
    {
      id: "1",
      source: "Main Job",
      amount: 5000,
      frequency: "monthly",
      type: "salary"
    },
    {
      id: "2",
      source: "Freelance Work",
      amount: 800,
      frequency: "monthly",
      type: "freelance"
    },
    {
      id: "3",
      source: "Investment Returns",
      amount: 150,
      frequency: "monthly",
      type: "investment"
    }
  ]);

  const totalMonthlyIncome = incomeItems.reduce((total, item) => {
    let monthlyAmount = item.amount;
    if (item.frequency === "weekly") monthlyAmount *= 4.33;
    if (item.frequency === "yearly") monthlyAmount /= 12;
    return total + monthlyAmount;
  }, 0);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!source || !amount) return;

    const newIncome: IncomeItem = {
      id: Date.now().toString(),
      source,
      amount: parseFloat(amount),
      frequency,
      type
    };

    setIncomeItems([...incomeItems, newIncome]);
    setSource("");
    setAmount("");
    setShowAddForm(false);
  };

  const handleDelete = (id: string) => {
    setIncomeItems(incomeItems.filter(item => item.id !== id));
  };

  const getFrequencyLabel = (frequency: string) => {
    return frequency.charAt(0).toUpperCase() + frequency.slice(1);
  };

  const getTypeColor = (type: string) => {
    const colors = {
      salary: "bg-primary text-primary-foreground",
      freelance: "bg-secondary text-secondary-foreground",
      investment: "bg-accent text-accent-foreground",
      other: "bg-muted text-muted-foreground"
    };
    return colors[type as keyof typeof colors] || colors.other;
  };

  return (
    <div className="min-h-screen bg-background">
      <div className="container mx-auto px-4 py-6">
        {/* Header */}
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center">
            <Button 
              variant="ghost" 
              size="icon" 
              onClick={() => navigate("/")}
              className="mr-3"
            >
              <ArrowLeft className="h-5 w-5" />
            </Button>
            <h1 className="text-2xl font-bold text-foreground">Income & Assets</h1>
          </div>
          <Button onClick={() => setShowAddForm(true)}>
            <Plus className="h-4 w-4 mr-2" />
            Add Income
          </Button>
        </div>

        {/* Total Income Overview */}
        <Card className="mb-6">
          <CardHeader className="text-center">
            <CardTitle className="text-3xl font-bold text-card-foreground">
              ${totalMonthlyIncome.toFixed(2)}
            </CardTitle>
            <p className="text-muted-foreground">Total Monthly Income</p>
          </CardHeader>
        </Card>

        {/* Add Income Form */}
        {showAddForm && (
          <Card className="mb-6">
            <CardHeader>
              <CardTitle>Add New Income Source</CardTitle>
            </CardHeader>
            <CardContent>
              <form onSubmit={handleSubmit} className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="source">Income Source</Label>
                  <Input
                    id="source"
                    placeholder="e.g., Main Job, Freelance, Investments"
                    value={source}
                    onChange={(e) => setSource(e.target.value)}
                    required
                  />
                </div>

                <div className="space-y-2">
                  <Label htmlFor="amount">Amount</Label>
                  <Input
                    id="amount"
                    type="number"
                    placeholder="0.00"
                    value={amount}
                    onChange={(e) => setAmount(e.target.value)}
                    step="0.01"
                    required
                  />
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-2">
                    <Label htmlFor="frequency">Frequency</Label>
                    <Select value={frequency} onValueChange={(value: any) => setFrequency(value)}>
                      <SelectTrigger>
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="weekly">Weekly</SelectItem>
                        <SelectItem value="monthly">Monthly</SelectItem>
                        <SelectItem value="yearly">Yearly</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="space-y-2">
                    <Label htmlFor="type">Type</Label>
                    <Select value={type} onValueChange={(value: any) => setType(value)}>
                      <SelectTrigger>
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value="salary">Salary</SelectItem>
                        <SelectItem value="freelance">Freelance</SelectItem>
                        <SelectItem value="investment">Investment</SelectItem>
                        <SelectItem value="other">Other</SelectItem>
                      </SelectContent>
                    </Select>
                  </div>
                </div>

                <div className="flex space-x-2">
                  <Button type="submit" className="flex-1">
                    Add Income
                  </Button>
                  <Button 
                    type="button" 
                    variant="outline" 
                    onClick={() => setShowAddForm(false)}
                    className="flex-1"
                  >
                    Cancel
                  </Button>
                </div>
              </form>
            </CardContent>
          </Card>
        )}

        {/* Income Items List */}
        <div className="space-y-3">
          {incomeItems.map((item) => (
            <Card key={item.id}>
              <CardContent className="p-4">
                <div className="flex justify-between items-start">
                  <div className="flex-1">
                    <h3 className="font-semibold text-card-foreground mb-2">
                      {item.source}
                    </h3>
                    <div className="flex items-center space-x-2">
                      <span className={`text-xs px-2 py-1 rounded ${getTypeColor(item.type)}`}>
                        {item.type}
                      </span>
                      <span className="text-sm text-muted-foreground">
                        {getFrequencyLabel(item.frequency)}
                      </span>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="text-lg font-bold text-card-foreground">
                      ${item.amount.toFixed(2)}
                    </p>
                    <p className="text-sm text-muted-foreground">
                      {item.frequency}
                    </p>
                  </div>
                  <div className="flex space-x-1 ml-3">
                    <Button size="icon" variant="ghost">
                      <Edit className="h-4 w-4" />
                    </Button>
                    <Button 
                      size="icon" 
                      variant="ghost"
                      onClick={() => handleDelete(item.id)}
                    >
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        {incomeItems.length === 0 && !showAddForm && (
          <div className="text-center py-12">
            <p className="text-muted-foreground mb-4">No income sources added yet</p>
            <Button onClick={() => setShowAddForm(true)}>
              Add Your First Income Source
            </Button>
          </div>
        )}
      </div>
    </div>
  );
};

export default Income;