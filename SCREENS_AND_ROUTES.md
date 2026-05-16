# ADVSW Screens & Routes Documentation

## Overview
Generated 4 screens based on your FR.txt requirements, using AppColors and AppTheme. All screens are built with Riverpod state management and follow your design system.

---

## 1. **GlobalSearchScreen** (FR31, FR32)
**Path:** `lib/features/search/global_search_screen.dart`

### Features
- Unified search hub with tabbed interface (Users & Projects)
- Search users by name or skills (FR31, FR32)
- Browse projects with status badges
- Request to join projects directly from search results
- Pull-to-refresh functionality
- Empty states and error handling

### Use Cases
- FR31: Search Users by Name
- FR32: Search Users by Skills
- FR33: Browse Projects (integrated)
- FR34: Request to Join Project (integrated)

### Route
```dart
GoRoute(
  path: '/search',
  name: 'search',
  builder: (c, s) => const GlobalSearchScreen(),
),
```

**Navigation:**
```dart
context.go('/search');
// or use named route
context.goNamed('search');
```

---

## 2. **ProjectDiscoveryScreen** (FR33, FR34)
**Path:** `lib/features/discovery/project_discovery_screen.dart`

### Features
- Browse available projects with search functionality
- Filter by project name/description
- Status badges (Open, In Progress, Completed, Cancelled)
- "Request to Join" button for each project (FR34)
- Pull-to-refresh
- Loading and error states

### Use Cases
- FR33: Browse Projects
- FR34: Request to Join Project

### Route
```dart
GoRoute(
  path: '/discover',
  name: 'discover',
  builder: (c, s) => const ProjectDiscoveryScreen(),
),
```

**Navigation:**
```dart
context.go('/discover');
context.goNamed('discover');
```

---

## 3. **MemberManagementScreen** (FR20, FR21)
**Path:** `lib/features/project_management/member_management_screen.dart`

### Features
- View all project members with their roles
- Change member roles (FR21)
- Remove members from project (FR20)
- Role management with dialogs
- Confirmation dialogs for destructive actions
- Refresh functionality

### Use Cases
- FR20: Remove Member
- FR21: Edit Member Role

### Route
```dart
GoRoute(
  path: '/project/:id/manage-members',
  name: 'member-management',
  builder: (context, state) {
    final projectId = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
    return MemberManagementScreen(projectId: projectId);
  },
),
```

**Navigation:**
```dart
context.goNamed('member-management', pathParameters: {'id': projectId.toString()});
// or
context.go('/project/$projectId/manage-members');
```

---

## 4. **PortfolioUpdateScreen** (FR11, FR12)
**Path:** `lib/features/profile_management/portfolio_update_screen.dart`

### Features
- Experience level dropdown (Beginner, Intermediate, Advanced, Expert) with descriptions (FR12)
- Add past projects with name, description, and optional link (FR11)
- Edit and remove past projects
- Professional portfolio management
- Styled cards and forms using AppTheme
- Success/error feedback

### Use Cases
- FR11: Add Past Projects
- FR12: Specify Experience Level

### Route
```dart
GoRoute(
  path: '/portfolio-update',
  name: 'portfolio-update',
  builder: (context, state) => const PortfolioUpdateScreen(),
),
```

**Navigation:**
```dart
context.goNamed('portfolio-update');
// or
context.go('/portfolio-update');
```

---

## Updated GoRouter Configuration

### Complete Routes Summary

| Route | Name | Screen | Purpose |
|-------|------|--------|---------|
| `/search` | `search` | GlobalSearchScreen | Search hub (Users & Projects) |
| `/discover` | `discover` | ProjectDiscoveryScreen | Browse projects & request to join |
| `/project/:id/members` | `project-members` | ProjectMembersScreen | View project members |
| `/project/:id/manage-members` | `member-management` | MemberManagementScreen | Manage member roles & remove |
| `/portfolio-update` | `portfolio-update` | PortfolioUpdateScreen | Update experience & past projects |
| `/edit-profile` | - | EditProfileScreen | Edit profile information |

### Tab Navigation (StatefulShellRoute)

The app uses a 5-tab bottom navigation:

```
0. Home              (/home)
1. Discover          (/discover)              - FR33, FR34
2. Search            (/search)                - FR31, FR32
3. Profile           (/profile)
4. Notifications     (/notifications)
```

---

## How to Use These Screens

### From Bottom Navigation
```dart
// Search tab automatically shows GlobalSearchScreen
// Discover tab automatically shows ProjectDiscoveryScreen
```

### Programmatic Navigation

#### Go to Portfolio Update
```dart
context.goNamed('portfolio-update');
```

#### Go to Member Management
```dart
context.goNamed('member-management', pathParameters: {'id': '123'});
```

#### Go to View Project Members
```dart
context.goNamed('project-members', pathParameters: {'id': '123'});
```

---

## Theme Integration

All screens use:
- **Colors:** AppColors (teal palette, warm accents, success states)
- **Typography:** Google Fonts (Inter for headers, Manrope for body)
- **Shadows:** AppTheme.shadowSm, shadowMd, shadowLg
- **Spacing:** Consistent 16px/20px padding
- **Components:** Custom cards, buttons, and input fields

### Key Color Usage
- **Primary Actions:** AppColors.teal700 (buttons, highlights)
- **Success Messages:** AppColors.success700
- **Text:** AppColors.ink900 (headers), AppColors.ink600 (body)
- **Borders:** AppColors.line, AppColors.lineSoft
- **Backgrounds:** AppColors.bg, AppColors.bgAlt

---

## State Management

All screens use Riverpod providers:

- `userSearchProvider` - User search functionality
- `projectSearchProvider` - Project search functionality
- `projectMembersProvider` - Project members list & management
- `userProfileProvider` - User profile & portfolio data
- `userInvitationsProvider` - Join request functionality

---

## Next Steps

1. **Update Providers** - Ensure providers have `updatePortfolio()` method for PortfolioUpdateScreen
2. **Add Navigation** - Update your UI buttons/links to navigate to these screens
3. **Test Routes** - Verify all GoRouter paths work correctly
4. **Add to MainApp** - The routes are already integrated in app_router.dart

---

## Functional Requirements Covered

✅ **FR11** - Add Past Projects (PortfolioUpdateScreen)  
✅ **FR12** - Specify Experience Level (PortfolioUpdateScreen)  
✅ **FR20** - Remove Member (MemberManagementScreen)  
✅ **FR21** - Edit Member Role (MemberManagementScreen)  
✅ **FR31** - Search Users by Name (GlobalSearchScreen)  
✅ **FR32** - Search Users by Skills (GlobalSearchScreen)  
✅ **FR33** - Browse Projects (ProjectDiscoveryScreen & GlobalSearchScreen)  
✅ **FR34** - Request to Join Project (ProjectDiscoveryScreen & GlobalSearchScreen)
