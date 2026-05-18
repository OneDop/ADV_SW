import 'package:advsw/models/user_model.dart';
import 'package:advsw/models/project_model.dart';
import 'package:advsw/models/task_model.dart';
import 'package:advsw/models/invitation_model.dart';
import 'package:advsw/models/notification_model.dart';
import 'package:advsw/models/message_model.dart';
import 'package:advsw/models/skill_model.dart';
import 'package:advsw/models/search_model.dart';
import 'package:advsw/models/rating_model.dart';

class MockData {
  static const int currentUserId = 1;

  // ── Users ─────────────────────────────────────────────────────────────────

  static UserProfileResponse currentUser = UserProfileResponse(
    id: 1,
    email: 'demo@projectpal.app',
    firstName: 'Alex',
    lastName: 'Demo',
    bio: 'Full-stack developer passionate about building great products. '
        'Experienced with mobile, web, and backend systems.',
    role: Role.USER,
    availabilityStatus: AvailabilityStatus.AVAILABLE,
    skills: [
      UserSkillResponse(id: 1, userId: 1, skillId: 1, skillName: 'Flutter', experienceLevel: ExperienceLevel.ADVANCED),
      UserSkillResponse(id: 2, userId: 1, skillId: 3, skillName: 'Spring Boot', experienceLevel: ExperienceLevel.INTERMEDIATE),
      UserSkillResponse(id: 3, userId: 1, skillId: 2, skillName: 'React', experienceLevel: ExperienceLevel.BEGINNER),
    ],
    pastProjects: [],
    averageRating: 4.5,
  );

  static final Map<int, UserProfileResponse> otherUsers = {
    2: UserProfileResponse(
      id: 2,
      email: 'bob@demo.com',
      firstName: 'Bob',
      lastName: 'Smith',
      bio: 'Mobile developer focused on React Native and Flutter. Loves clean UI.',
      role: Role.USER,
      availabilityStatus: AvailabilityStatus.AVAILABLE,
      skills: [
        UserSkillResponse(id: 4, userId: 2, skillId: 1, skillName: 'Flutter', experienceLevel: ExperienceLevel.INTERMEDIATE),
        UserSkillResponse(id: 5, userId: 2, skillId: 2, skillName: 'React', experienceLevel: ExperienceLevel.BEGINNER),
      ],
      pastProjects: [],
      averageRating: 3.8,
    ),
    3: UserProfileResponse(
      id: 3,
      email: 'carol@demo.com',
      firstName: 'Carol',
      lastName: 'Jones',
      bio: 'Backend engineer specialising in Java microservices and system design.',
      role: Role.USER,
      availabilityStatus: AvailabilityStatus.AVAILABLE,
      skills: [
        UserSkillResponse(id: 6, userId: 3, skillId: 3, skillName: 'Spring Boot', experienceLevel: ExperienceLevel.ADVANCED),
        UserSkillResponse(id: 7, userId: 3, skillId: 4, skillName: 'Python', experienceLevel: ExperienceLevel.INTERMEDIATE),
      ],
      pastProjects: [],
      averageRating: 4.2,
    ),
    4: UserProfileResponse(
      id: 4,
      email: 'dave@demo.com',
      firstName: 'Dave',
      lastName: 'Wilson',
      bio: 'DevOps and infrastructure engineer. Expert in containerisation and CI/CD.',
      role: Role.USER,
      availabilityStatus: AvailabilityStatus.AWAY,
      skills: [
        UserSkillResponse(id: 8, userId: 4, skillId: 6, skillName: 'Docker', experienceLevel: ExperienceLevel.PROFESSIONAL),
        UserSkillResponse(id: 9, userId: 4, skillId: 5, skillName: 'TypeScript', experienceLevel: ExperienceLevel.ADVANCED),
      ],
      pastProjects: [],
      averageRating: 4.7,
    ),
    5: UserProfileResponse(
      id: 5,
      email: 'eve@demo.com',
      firstName: 'Eve',
      lastName: 'Martinez',
      bio: 'UI/UX designer who codes. Passionate about accessibility and design systems.',
      role: Role.USER,
      availabilityStatus: AvailabilityStatus.AVAILABLE,
      skills: [
        UserSkillResponse(id: 10, userId: 5, skillId: 1, skillName: 'Flutter', experienceLevel: ExperienceLevel.BEGINNER),
        UserSkillResponse(id: 11, userId: 5, skillId: 2, skillName: 'React', experienceLevel: ExperienceLevel.ADVANCED),
      ],
      pastProjects: [],
      averageRating: 4.0,
    ),
  };

  // ── Projects ───────────────────────────────────────────────────────────────

  static List<ProjectResponse> myProjects = [
    ProjectResponse(
      id: 1,
      name: 'Mobile Shopping App',
      description: 'A cross-platform mobile app for e-commerce with real-time inventory tracking and seamless checkout.',
      status: ProjectStatus.OPEN,
      ownerId: 1,
      ownerName: 'Alex Demo',
      isDeleted: false,
    ),
    ProjectResponse(
      id: 2,
      name: 'AI Chat Assistant',
      description: 'An intelligent chatbot powered by large language models to handle customer support queries.',
      status: ProjectStatus.IN_PROGRESS,
      ownerId: 1,
      ownerName: 'Alex Demo',
      isDeleted: false,
    ),
    ProjectResponse(
      id: 3,
      name: 'Portfolio Website',
      description: 'A personal portfolio site showcasing projects, skills, and blog posts.',
      status: ProjectStatus.COMPLETED,
      ownerId: 2,
      ownerName: 'Bob Smith',
      isDeleted: false,
    ),
  ];

  static final List<ProjectResponse> browseProjects = [
    ProjectResponse(
      id: 4,
      name: 'Blockchain Wallet',
      description: 'A secure multi-chain crypto wallet with DeFi integration and hardware key support.',
      status: ProjectStatus.OPEN,
      ownerId: 3,
      ownerName: 'Carol Jones',
      isDeleted: false,
    ),
    ProjectResponse(
      id: 5,
      name: 'Social Media Dashboard',
      description: 'Unified analytics dashboard that aggregates data from multiple social platforms in real time.',
      status: ProjectStatus.OPEN,
      ownerId: 4,
      ownerName: 'Dave Wilson',
      isDeleted: false,
    ),
    ProjectResponse(
      id: 6,
      name: 'Real-time Analytics',
      description: 'Streaming data pipeline and visualisation platform for business intelligence.',
      status: ProjectStatus.OPEN,
      ownerId: 5,
      ownerName: 'Eve Martinez',
      isDeleted: false,
    ),
  ];

  // ── Members ────────────────────────────────────────────────────────────────

  static final Map<int, List<ProjectMemberResponse>> projectMembers = {
    1: [
      ProjectMemberResponse(userId: 1, email: 'demo@projectpal.app', firstName: 'Alex', lastName: 'Demo', memberRole: MemberRole.OWNER),
      ProjectMemberResponse(userId: 2, email: 'bob@demo.com', firstName: 'Bob', lastName: 'Smith', memberRole: MemberRole.MEMBER),
      ProjectMemberResponse(userId: 3, email: 'carol@demo.com', firstName: 'Carol', lastName: 'Jones', memberRole: MemberRole.MEMBER),
    ],
    2: [
      ProjectMemberResponse(userId: 1, email: 'demo@projectpal.app', firstName: 'Alex', lastName: 'Demo', memberRole: MemberRole.OWNER),
      ProjectMemberResponse(userId: 4, email: 'dave@demo.com', firstName: 'Dave', lastName: 'Wilson', memberRole: MemberRole.ADMIN),
    ],
    3: [
      ProjectMemberResponse(userId: 2, email: 'bob@demo.com', firstName: 'Bob', lastName: 'Smith', memberRole: MemberRole.OWNER),
      ProjectMemberResponse(userId: 1, email: 'demo@projectpal.app', firstName: 'Alex', lastName: 'Demo', memberRole: MemberRole.MEMBER),
    ],
    4: [
      ProjectMemberResponse(userId: 3, email: 'carol@demo.com', firstName: 'Carol', lastName: 'Jones', memberRole: MemberRole.OWNER),
    ],
    5: [
      ProjectMemberResponse(userId: 4, email: 'dave@demo.com', firstName: 'Dave', lastName: 'Wilson', memberRole: MemberRole.OWNER),
      ProjectMemberResponse(userId: 5, email: 'eve@demo.com', firstName: 'Eve', lastName: 'Martinez', memberRole: MemberRole.MEMBER),
    ],
    6: [
      ProjectMemberResponse(userId: 5, email: 'eve@demo.com', firstName: 'Eve', lastName: 'Martinez', memberRole: MemberRole.OWNER),
    ],
  };

  // ── Tasks ──────────────────────────────────────────────────────────────────

  static int _nextTaskId = 10;
  static int nextTaskId() => _nextTaskId++;

  static Map<int, List<TaskResponse>> tasksByProject = {
    1: [
      TaskResponse(
        id: 1, title: 'Design login screen',
        description: 'Create wireframes and high-fidelity mockups for the login and signup flows.',
        status: TaskStatus.DONE, projectId: 1,
        assigneeId: 1, assigneeName: 'Alex Demo',
        isDeleted: false,
        deadline: DateTime.now().subtract(const Duration(days: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      TaskResponse(
        id: 2, title: 'Build product listing',
        description: 'Implement the product catalogue screen with search, filters, and pagination.',
        status: TaskStatus.IN_PROGRESS, projectId: 1,
        assigneeId: 2, assigneeName: 'Bob Smith',
        isDeleted: false,
        deadline: DateTime.now().add(const Duration(days: 4)),
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TaskResponse(
        id: 3, title: 'Setup push notifications',
        description: 'Integrate Firebase Cloud Messaging for order status and promotional notifications.',
        status: TaskStatus.TODO, projectId: 1,
        isDeleted: false,
        deadline: DateTime.now().add(const Duration(days: 7)),
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        updatedAt: DateTime.now().subtract(const Duration(days: 6)),
      ),
      TaskResponse(
        id: 4, title: 'Write API documentation',
        description: 'Document all REST endpoints using OpenAPI / Swagger annotations.',
        status: TaskStatus.TODO, projectId: 1,
        isDeleted: false,
        deadline: DateTime.now().add(const Duration(days: 14)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ],
    2: [
      TaskResponse(
        id: 5, title: 'Train NLP model',
        description: 'Fine-tune the base language model on domain-specific customer support data.',
        status: TaskStatus.TODO, projectId: 2,
        isDeleted: false,
        deadline: DateTime.now().add(const Duration(days: 10)),
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      TaskResponse(
        id: 6, title: 'Build chat UI',
        description: 'Implement the real-time chat interface with message threading and file attachments.',
        status: TaskStatus.IN_PROGRESS, projectId: 2,
        assigneeId: 1, assigneeName: 'Alex Demo',
        isDeleted: false,
        deadline: DateTime.now().add(const Duration(days: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 9)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TaskResponse(
        id: 7, title: 'Deploy to production',
        description: 'Set up Kubernetes cluster, CI/CD pipeline, and deploy the application.',
        status: TaskStatus.TODO, projectId: 2,
        isDeleted: false,
        deadline: DateTime.now().add(const Duration(days: 21)),
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        updatedAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ],
    3: [
      TaskResponse(
        id: 8, title: 'Create design system',
        description: 'Build reusable component library with consistent theming and documentation.',
        status: TaskStatus.DONE, projectId: 3,
        assigneeId: 3, assigneeName: 'Carol Jones',
        isDeleted: false,
        deadline: DateTime.now().subtract(const Duration(days: 14)),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
      TaskResponse(
        id: 9, title: 'Implement contact form',
        description: 'Add validated contact form with email delivery and spam protection.',
        status: TaskStatus.DONE, projectId: 3,
        assigneeId: 1, assigneeName: 'Alex Demo',
        isDeleted: false,
        deadline: DateTime.now().subtract(const Duration(days: 7)),
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        updatedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ],
  };

  // ── Skills ─────────────────────────────────────────────────────────────────

  static final List<SkillResponse> allSkills = [
    SkillResponse(id: 1, name: 'Flutter'),
    SkillResponse(id: 2, name: 'React'),
    SkillResponse(id: 3, name: 'Spring Boot'),
    SkillResponse(id: 4, name: 'Python'),
    SkillResponse(id: 5, name: 'TypeScript'),
    SkillResponse(id: 6, name: 'Docker'),
    SkillResponse(id: 7, name: 'Figma'),
    SkillResponse(id: 8, name: 'SwiftUI'),
    SkillResponse(id: 9, name: 'Kotlin'),
    SkillResponse(id: 10, name: 'GraphQL'),
  ];

  // ── Notifications ──────────────────────────────────────────────────────────

  static List<NotificationResponse> notifications = [
    NotificationResponse(
      id: 1, recipientId: 1,
      type: NotificationType.TASK_ASSIGNED,
      message: "You've been assigned to 'Build chat UI' in AI Chat Assistant.",
      projectId: 2, projectName: 'AI Chat Assistant', senderId: 1,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationResponse(
      id: 2, recipientId: 1,
      type: NotificationType.NEW_MESSAGE,
      message: 'Bob Smith sent a message in Mobile Shopping App.',
      projectId: 1, projectName: 'Mobile Shopping App', senderId: 2,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationResponse(
      id: 3, recipientId: 1,
      type: NotificationType.DEADLINE_REMINDER,
      message: "Task 'Build product listing' is due in 4 days.",
      projectId: 1, projectName: 'Mobile Shopping App',
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    NotificationResponse(
      id: 4, recipientId: 1,
      type: NotificationType.JOIN_APPROVED,
      message: 'Your join request for Portfolio Website was approved.',
      projectId: 3, projectName: 'Portfolio Website', senderId: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // ── Invitations ────────────────────────────────────────────────────────────

  static List<InvitationResponse> userInvitations = [
    InvitationResponse(
      id: 1, projectId: 6, projectName: 'Real-time Analytics',
      senderId: 5, senderName: 'Eve Martinez',
      receiverId: 1, receiverName: 'Alex Demo',
      status: InvitationStatus.PENDING,
      type: InvitationType.INVITE,
    ),
  ];

  static List<InvitationResponse> ownerJoinRequests = [
    InvitationResponse(
      id: 2, projectId: 1, projectName: 'Mobile Shopping App',
      senderId: 4, senderName: 'Dave Wilson',
      receiverId: 1, receiverName: 'Alex Demo',
      status: InvitationStatus.PENDING,
      type: InvitationType.JOIN_REQUEST,
    ),
  ];

  // ── Messages ───────────────────────────────────────────────────────────────

  static Map<int, List<MessageResponse>> messagesByProject = {
    1: [
      MessageResponse(id: 1, projectId: 1, senderId: 1, senderName: 'Alex Demo',
          content: "Hey team, let's get started on the shopping app! 🚀",
          sentAt: DateTime.now().subtract(const Duration(hours: 6))),
      MessageResponse(id: 2, projectId: 1, senderId: 2, senderName: 'Bob Smith',
          content: "Sounds great! I'll start on the product listing UI.",
          sentAt: DateTime.now().subtract(const Duration(hours: 5, minutes: 45))),
      MessageResponse(id: 3, projectId: 1, senderId: 3, senderName: 'Carol Jones',
          content: 'I can help with the design components. Shall we use a shared Figma file?',
          sentAt: DateTime.now().subtract(const Duration(hours: 5, minutes: 30))),
      MessageResponse(id: 4, projectId: 1, senderId: 1, senderName: 'Alex Demo',
          content: "Perfect. Let's aim to have a prototype ready by next week.",
          sentAt: DateTime.now().subtract(const Duration(hours: 5))),
    ],
    2: [
      MessageResponse(id: 5, projectId: 2, senderId: 1, senderName: 'Alex Demo',
          content: 'Welcome to the AI Chat project! Excited to work with everyone.',
          sentAt: DateTime.now().subtract(const Duration(days: 2))),
      MessageResponse(id: 6, projectId: 2, senderId: 4, senderName: 'Dave Wilson',
          content: "Thanks! I'll set up the infrastructure and deployment pipeline first.",
          sentAt: DateTime.now().subtract(const Duration(days: 1, hours: 22))),
    ],
    3: [
      MessageResponse(id: 7, projectId: 3, senderId: 2, senderName: 'Bob Smith',
          content: 'Great work everyone — the portfolio site is live! 🎉',
          sentAt: DateTime.now().subtract(const Duration(days: 7))),
    ],
  };

  static int _nextMessageId = 20;
  static int nextMessageId() => _nextMessageId++;

  // ── Ratings ────────────────────────────────────────────────────────────────

  static final List<RatingResponse> ratingsForCurrentUser = [
    RatingResponse(id: 1, raterId: 2, raterName: 'Bob Smith',
        rateeId: 1, rateeName: 'Alex Demo', projectId: 3, score: 5),
    RatingResponse(id: 2, raterId: 3, raterName: 'Carol Jones',
        rateeId: 1, rateeName: 'Alex Demo', projectId: 3, score: 4),
  ];

  // ── Search ─────────────────────────────────────────────────────────────────

  static final List<SearchUserResult> searchableUsers = [
    SearchUserResult(
      id: 2, firstName: 'Bob', lastName: 'Smith', email: 'bob@demo.com',
      bio: 'Mobile developer focused on React Native and Flutter.',
      skills: [
        SkillEntry(skillName: 'Flutter', experienceLevel: 'INTERMEDIATE'),
        SkillEntry(skillName: 'React', experienceLevel: 'BEGINNER'),
      ],
    ),
    SearchUserResult(
      id: 3, firstName: 'Carol', lastName: 'Jones', email: 'carol@demo.com',
      bio: 'Backend engineer specialising in Java microservices.',
      skills: [
        SkillEntry(skillName: 'Spring Boot', experienceLevel: 'ADVANCED'),
        SkillEntry(skillName: 'Python', experienceLevel: 'INTERMEDIATE'),
      ],
    ),
    SearchUserResult(
      id: 4, firstName: 'Dave', lastName: 'Wilson', email: 'dave@demo.com',
      bio: 'DevOps and infrastructure engineer.',
      skills: [
        SkillEntry(skillName: 'Docker', experienceLevel: 'PROFESSIONAL'),
        SkillEntry(skillName: 'TypeScript', experienceLevel: 'ADVANCED'),
      ],
    ),
    SearchUserResult(
      id: 5, firstName: 'Eve', lastName: 'Martinez', email: 'eve@demo.com',
      bio: 'UI/UX designer who codes.',
      skills: [
        SkillEntry(skillName: 'Flutter', experienceLevel: 'BEGINNER'),
        SkillEntry(skillName: 'React', experienceLevel: 'ADVANCED'),
      ],
    ),
  ];

  static final List<SearchProjectResult> searchableProjects = [
    SearchProjectResult(id: 4, name: 'Blockchain Wallet',
        description: 'A secure multi-chain crypto wallet with DeFi integration.', status: 'OPEN'),
    SearchProjectResult(id: 5, name: 'Social Media Dashboard',
        description: 'Unified analytics dashboard for multiple social platforms.', status: 'OPEN'),
    SearchProjectResult(id: 6, name: 'Real-time Analytics',
        description: 'Streaming data pipeline and visualisation platform.', status: 'OPEN'),
  ];
}
