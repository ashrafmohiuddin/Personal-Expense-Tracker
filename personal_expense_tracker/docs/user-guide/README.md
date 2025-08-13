# User Guide - Personal Expense Tracker

Welcome to the Personal Expense Tracker! This comprehensive guide will help you understand and use all the features of the application effectively.

## 📱 Getting Started

### First Launch
When you first open the app, you'll see:
- **Welcome Screen**: Brief introduction to the app
- **Sample Data**: Pre-loaded sample transactions and assets to help you understand the features
- **Tutorial**: Quick walkthrough of main features

### App Navigation
The app uses a bottom navigation bar with five main sections:
- 🏠 **Home** - Dashboard and overview
- 📝 **Add** - Quick transaction entry
- 📊 **Transactions** - View and manage transactions
- 📈 **Reports** - Financial analytics and insights
- 💰 **Assets** - Manage assets and income sources
- ⚙️ **Settings** - App preferences and configuration

## 🏠 Home Screen

The Home screen is your financial dashboard, providing a quick overview of your financial status.

### Hero Card
- **Today's Net Balance**: Shows your current financial position
- **Color Coding**: Green for positive balance, red for negative
- **Tap to View**: Tap the card to see detailed reports

### Quick Overview Cards
Two cards showing your financial performance:

#### Weekly Overview
- **Income**: Total income for the current week
- **Expenses**: Total expenses for the current week
- **Net**: Weekly net amount (income - expenses)
- **Delta Indicator**: ▲ for positive, ▼ for negative
- **Color Coding**: Green for positive, red for negative

#### Monthly Overview
- **Income**: Total income for the current month
- **Expenses**: Total expenses for the current month
- **Net**: Monthly net amount
- **Delta Indicator**: Shows change from previous month

### Assets Summary
- **Total Assets**: Sum of all your assets
- **Monthly Income**: Total recurring monthly income
- **Tap to Manage**: Tap to go to Assets screen

## 📝 Adding Transactions

### Quick Add (Floating Action Button)
1. Tap the **+** button on any screen
2. Choose transaction type:
   - **Expense** (red) - Money going out
   - **Income** (green) - Money coming in
3. Enter amount using the numeric keypad
4. Select category from the predefined list
5. Choose date (defaults to today)
6. Optionally add merchant and notes
7. Tap **Save**

### Transaction Types

#### Income Categories
- **Salary** - Regular employment income
- **Freelance** - Contract or freelance work
- **Investment** - Investment returns
- **Gifts** - Received gifts or money
- **Other** - Miscellaneous income

#### Expense Categories
- **Food & Dining** - Groceries, restaurants, takeout
- **Transportation** - Fuel, public transport, rideshare
- **Shopping** - Retail purchases, online shopping
- **Entertainment** - Movies, games, hobbies
- **Healthcare** - Medical expenses, prescriptions
- **Utilities** - Electricity, water, internet
- **Housing** - Rent, mortgage, maintenance
- **Education** - Tuition, books, courses
- **Travel** - Vacations, business trips
- **Other** - Miscellaneous expenses

### Form Validation
The app ensures data quality through validation:
- **Amount**: Must be a valid number greater than 0
- **Category**: Must be selected
- **Date**: Cannot be in the future
- **Save Button**: Only enabled when all required fields are valid

## 📊 Transactions Screen

### Viewing Transactions
- **List View**: All transactions in chronological order
- **Color Coding**: Green for income, red for expenses
- **Transaction Details**: Amount, category, date, merchant, notes
- **Icons**: Category-specific icons for easy identification

### Filtering Transactions
Use the segmented control at the top:
- **All** - Show all transactions
- **Income** - Show only income transactions
- **Expense** - Show only expense transactions

### Searching Transactions
Use the search bar to find specific transactions:
- **Category**: Search by category name
- **Merchant**: Search by merchant name
- **Notes**: Search within transaction notes
- **Real-time**: Results update as you type

### Advanced Filtering
Tap the filter icon (🔍) to access advanced filters:
- **Date Range**: This week, this month, last month, custom
- **Category**: Filter by specific categories
- **Amount Range**: Filter by transaction amounts

### Managing Transactions

#### Swipe Actions
Swipe left on any transaction to reveal actions:
- **Edit** (blue) - Modify transaction details
- **Delete** (red) - Remove transaction

#### Edit Transaction
1. Swipe and tap **Edit**
2. Modify any field (type, amount, category, date, merchant, notes)
3. Tap **Update Transaction**

#### Delete Transaction
1. Swipe and tap **Delete**
2. Transaction is immediately removed
3. **Undo Option**: Tap "Undo" in the snackbar to restore

## 📈 Reports Screen

### Period Selection
Use the period selector at the top:
- **This Week** - Current week's data
- **This Month** - Current month's data
- **Custom** - Select custom date range

### Financial Summary
Three main cards showing:
- **Income**: Total income for the selected period
- **Expenses**: Total expenses for the selected period
- **Net Savings**: Net amount (income - expenses)

### Expense Analysis

#### Donut Chart
- **Visual Representation**: Shows expenses by category
- **Color Coding**: Each category has a unique color
- **Legend**: Shows category, amount, and percentage
- **Interactive**: Tap legend items to highlight sections

#### Bar Chart
- **Income vs Expenses**: Side-by-side comparison
- **Scale**: Automatic scaling based on data
- **Legend**: Clear identification of bars

### Chart Legend
Each chart includes a detailed legend showing:
- **Category Name**: Name of the expense category
- **Amount**: Total amount for that category
- **Percentage**: Percentage of total expenses
- **Color Indicator**: Matching chart color

## 💰 Assets Screen

### Assets Overview
Two summary cards at the top:
- **Total Assets**: Sum of all your assets
- **Monthly Income**: Total recurring monthly income

### Recurring Income Section
Shows all assets marked as recurring:
- **Salary**: Regular employment income
- **Investments**: Regular investment returns
- **Other Recurring**: Any other regular income sources

### All Assets Section
Complete list of all your assets:
- **Asset Name**: Name you gave the asset
- **Amount**: Current value
- **Type**: Category (salary, investment, savings, other)
- **Recurring Badge**: Shows if it's recurring income
- **Description**: Additional details (if provided)

### Managing Assets

#### Add Asset
1. Tap the **+** button
2. Fill in the form:
   - **Asset Name**: Give it a descriptive name
   - **Amount**: Current value
   - **Asset Type**: Choose from predefined types
   - **Recurring**: Check if it's monthly recurring income
   - **Description**: Optional additional details
3. Tap **Add Asset**

#### Asset Types
- **Salary** - Employment income
- **Investment** - Investment accounts, stocks, bonds
- **Savings** - Savings accounts, emergency funds
- **Other** - Any other assets

#### Edit Asset
1. Swipe left on the asset
2. Tap **Edit**
3. Modify details
4. Tap **Update**

#### Delete Asset
1. Swipe left on the asset
2. Tap **Delete**
3. Confirm deletion
4. **Undo Option**: Available in snackbar

## ⚙️ Settings Screen

### Appearance Settings

#### Dark Mode
- **Toggle**: Switch between light and dark themes
- **System Default**: Follows your device's theme setting
- **Manual Override**: Choose your preferred theme

#### Reduced Motion
- **Accessibility**: Reduces animations for users with motion sensitivity
- **Performance**: May improve performance on older devices
- **Respects System**: Honors device accessibility settings

### Currency Settings
- **Current Currency**: Shows your selected currency
- **Change Currency**: Tap to select from available options
- **Supported Currencies**: INR (₹), USD ($), EUR (€), GBP (£), JPY (¥)
- **Formatting**: Automatically formats amounts in selected currency

### Data Management

#### Export Data
- **Format**: CSV file export
- **Content**: All transactions and assets
- **Location**: Downloads folder
- **Usage**: Backup or import to other applications

#### Import Data
- **Format**: CSV file import
- **Validation**: Checks data format before import
- **Conflict Resolution**: Handles duplicate entries
- **Backup**: Creates backup before import

#### Clear All Data
⚠️ **Warning**: This action cannot be undone!
- **Confirmation**: Requires explicit confirmation
- **Complete Reset**: Removes all transactions and assets
- **Fresh Start**: Returns app to initial state

### About Section
- **Version**: Current app version
- **Privacy Policy**: Link to privacy information
- **Terms of Service**: Link to terms and conditions

## 🎯 Tips and Best Practices

### Transaction Management
1. **Be Consistent**: Use the same categories regularly
2. **Add Details**: Include merchant names and notes for better tracking
3. **Regular Entry**: Enter transactions daily or weekly
4. **Review Regularly**: Check your reports monthly

### Category Management
1. **Use Default Categories**: Start with predefined categories
2. **Be Specific**: Choose the most specific category available
3. **Consistent Naming**: Use consistent merchant names

### Asset Management
1. **Update Regularly**: Keep asset values current
2. **Mark Recurring**: Properly mark recurring income sources
3. **Include All Assets**: Don't forget savings and investments

### Data Backup
1. **Regular Exports**: Export data monthly
2. **Multiple Backups**: Keep backups in different locations
3. **Test Imports**: Verify your backup files work

## 🔍 Troubleshooting

### Common Issues

#### App Won't Start
- **Restart Device**: Try restarting your device
- **Clear Cache**: Clear app cache in device settings
- **Reinstall**: Uninstall and reinstall the app

#### Data Not Saving
- **Check Storage**: Ensure device has sufficient storage
- **Permissions**: Grant necessary permissions
- **Restart App**: Close and reopen the app

#### Slow Performance
- **Reduce Data**: Delete old transactions if needed
- **Close Other Apps**: Free up device memory
- **Update App**: Ensure you have the latest version

#### Sync Issues
- **Check Internet**: Ensure stable internet connection
- **Restart Sync**: Toggle sync off and on
- **Contact Support**: If issues persist

### Getting Help
1. **Check FAQ**: Look for common questions
2. **Search Issues**: Check existing GitHub issues
3. **Create Issue**: Submit a new issue with details
4. **Contact Support**: Reach out to the development team

## 📱 Accessibility Features

### Visual Accessibility
- **High Contrast**: Support for high contrast themes
- **Large Text**: Scales with system text size
- **Color Blind Support**: Not color-dependent for information

### Motor Accessibility
- **Large Touch Targets**: Minimum 44x44 pixel touch areas
- **Swipe Gestures**: Alternative to small buttons
- **Voice Control**: Compatible with voice control systems

### Cognitive Accessibility
- **Simple Navigation**: Clear, consistent navigation
- **Clear Labels**: Descriptive button and field labels
- **Error Prevention**: Validation and confirmation dialogs

## 🔒 Privacy and Security

### Data Storage
- **Local Only**: All data stored on your device
- **No Cloud Sync**: No data sent to external servers
- **Encrypted**: Database encryption for sensitive data

### Data Control
- **Export**: Full control over your data export
- **Delete**: Complete data deletion option
- **No Tracking**: No analytics or tracking

### Permissions
- **Storage**: Required for database and file operations
- **No Network**: No internet permissions required
- **Minimal**: Only necessary permissions requested

---

This user guide covers all the features and functionality of the Personal Expense Tracker. For additional help or feature requests, please refer to the support section or create an issue on GitHub.
