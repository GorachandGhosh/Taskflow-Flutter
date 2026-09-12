/// User-facing strings and message constants.
class AppStrings {
  AppStrings._();

  // General App
  static const String appName = 'TaskFlow';
  static const String appTagline = 'Task management for gig workers';

  // Onboarding
  static const String onboardingHeadline = 'Get things done.';
  static const String onboardingSubtitle =
      'Organize your tasks, stay focused, and never miss an important deadline.';
  static const String onboardingButton = 'Get Started';

  // Auth - Login
  static const String loginTitle = 'Welcome back!';
  static const String loginSubtitle = 'Sign in to continue managing your tasks.';
  static const String emailLabel = 'Email Address';
  static const String emailHint = 'e.g. alex@example.com';
  static const String passwordLabel = 'Password';
  static const String passwordHint = 'Enter your password';
  static const String forgotPassword = 'Forgot password?';
  static const String loginButton = 'Log In';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String signUpLink = 'Sign Up';

  // Auth - Register
  static const String registerTitle = "Let's get started!";
  static const String registerSubtitle = 'Create an account to streamline your workflow.';
  static const String confirmPasswordLabel = 'Confirm Password';
  static const String confirmPasswordHint = 'Re-enter your password';
  static const String registerButton = 'Create Account';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String signInLink = 'Log In';

  // Home Screen
  static const String greetingMorning = 'Good morning 👋';
  static const String greetingAfternoon = 'Good afternoon ☀️';
  static const String greetingEvening = 'Good evening 🌙';
  static const String homeSubtitle = 'Stay productive and organized.';
  static const String searchHint = 'Search tasks...';
  static const String totalTasks = 'Total';
  static const String pendingTasks = 'Pending';
  static const String completedTasks = 'Done';
  static const String filterAll = 'All';
  static const String filterPending = 'Pending';
  static const String filterCompleted = 'Completed';
  static const String createTask = 'Create Task';

  // Task Card & Details
  static const String editTask = 'Edit Task';
  static const String deleteTask = 'Delete Task';
  static const String deleteConfirmationTitle = 'Delete Task?';
  static const String deleteConfirmationMessage =
      'Are you sure you want to delete this task? This action cannot be undone.';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String markComplete = 'Mark as Completed';
  static const String markIncomplete = 'Mark as Incomplete';

  // Add / Edit Task Form
  static const String titleLabel = 'Task Title';
  static const String titleHint = 'What needs to be done?';
  static const String descriptionLabel = 'Description';
  static const String descriptionHint = 'Add any notes, gig details, or context...';
  static const String dueDateLabel = 'Due Date';
  static const String selectDate = 'Select date';
  static const String priorityLabel = 'Priority';
  static const String saveChanges = 'Save Changes';

  // Priorities
  static const String priorityLow = 'Low';
  static const String priorityMedium = 'Medium';
  static const String priorityHigh = 'High';

  // Filter Sheet
  static const String filterSheetTitle = 'Filter Tasks';
  static const String filterByPriority = 'Priority';
  static const String filterByStatus = 'Status';
  static const String resetFilters = 'Reset';
  static const String applyFilters = 'Apply';

  // Empty States
  static const String emptyTasksTitle = 'No tasks yet';
  static const String emptyTasksSubtitle = 'Create your first task and stay organized.';
  static const String emptySearchTitle = 'No matching tasks';
  static const String emptySearchSubtitle = 'Try changing your filters or search terms.';

  // Error Messages
  static const String errEmailRequired = 'Please enter your email.';
  static const String errEmailInvalid = 'Please enter a valid email address.';
  static const String errPasswordRequired = 'Please enter your password.';
  static const String errPasswordTooShort = 'Password must be at least 6 characters.';
  static const String errPasswordMismatch = 'Passwords do not match.';
  static const String errTitleRequired = 'Task title is required.';
  static const String errDescriptionRequired = 'Task description is required.';
  static const String errDueDateRequired = 'Please select a due date.';
  static const String errGeneric = 'Something went wrong. Please try again.';
  static const String errInvalidCredentials = 'Invalid email or password.';
  static const String errUserNotFound = 'No user found with this email.';
  static const String errEmailInUse = 'This email is already registered.';
  static const String errNetwork = 'Network error. Please check your internet connection.';
}
