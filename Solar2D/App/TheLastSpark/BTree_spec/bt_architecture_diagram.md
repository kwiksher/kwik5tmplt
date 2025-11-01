# Behavior Tree Architecture Diagram

```mermaid
graph TD
    A[main.lua] --> B[btree.lua]
    A --> C[Models]
    A --> D[Views]
    A --> E[Actions]
    A --> F[Conditions]
    A --> G[Utils]

    B --> H[Node Types]
    H --> H1[Selector]
    H --> H2[Sequence]
    H --> H3[Decorator]
    H --> H4[Condition]
    H --> H5[Action]

    E --> E1[action_controller.lua]
    E --> E2[Individual Action Files]

    F --> F1[condition_controller.lua]
    F --> F2[Individual Condition Files]

    C --> C1[Entity Models]
    D --> D1[Entity Views]

    G --> G1[file_loader.lua]
    G --> G2[Helper Functions]

    I[.tree File] --> A

    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style C fill:#e8f5e8
    style D fill:#e8f5e8
    style E fill:#fff3e0
    style F fill:#fff3e0
    style G fill:#fce4ec
    style H fill:#f3e5f5
```

This diagram shows the relationships between components in the Behavior Tree architecture. The main.lua file serves as the entry point and orchestrates all other components. The btree.lua implements the core behavior tree logic, while models, views, actions, conditions, and utilities provide specialized functionality.