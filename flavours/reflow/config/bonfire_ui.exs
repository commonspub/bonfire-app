import Config


config :bonfire, :ui,
   sidebar_components: [
      {Bonfire.UI.Reflow.SidebarNavigationLive, []},
      {Bonfire.UI.ValueFlows.ProcessesListLive, [title: "Processes", process_url: "/process/"]},
      # {Bonfire.UI.ValueFlows.ProcessesListLive, [title: "Task Lists", process_url: "/list/"]}
   ],
   smart_input: [
      post: false,
      cw: true,
      summary: true
   ],
   profile: [
      sections: [
         timeline: Bonfire.UI.Social.ProfileTimelineLive,
         private: Bonfire.UI.Social.PrivateLive,
         posts: Bonfire.UI.Social.ProfilePostsLive,
         boosts: Bonfire.UI.Social.ProfileBoostsLive,
         followers: Bonfire.UI.Social.ProfileFollowersLive,
         followed: Bonfire.UI.Social.ProfileFollowersLive,
         inventory: Bonfire.UI.Reflow.ProfileInventoryLive,
      ],
      navigation: [
         timeline: "timeline",
         inventory: "inventory",
         # posts: "posts",
         # boosts: "boosts",
         # private: "private",
      ],
      widgets: [
      ],
   ],
   smart_input_activities: [
      # offer: "Publish an offer",
      # need: "Publish a need",
      # transfer_resource: "Transfer a resource",
      # produce_resource: "Add a resource",
      # intent: "Indicate an itent",
      # economic_event: "Record an economic event",
      # process: "Define a process"
   ],
   smart_input_forms: [
      post: Bonfire.UI.Social.CreateActivityLive,
      economic_event: Bonfire.UI.ValueFlows.SelectEconomicEventLive,
      intent: Bonfire.UI.ValueFlows.CreateIntentLive,
      process: Bonfire.UI.ValueFlows.CreateProcessLive,
      #offer: Bonfire.UI.ValueFlows.CreateOfferWidgetLive
      # need:
      transfer_resource: Bonfire.UI.ValueFlows.CreateOfferWidgetLive,
      produce_resource: Bonfire.UI.ValueFlows.CreateOfferWidgetLive
   ],
   resource: [
      navigation: [
         trace: "material passport",
         track: "next events",
      ],
      widgets: [
        # Bonfire.UI.Social.SubscribeWidgetLive,
         Bonfire.UI.ValueFlows.LocationWidgetLive,
         Bonfire.UI.ValueFlows.PrimaryAccountableWidgetLive,
         Bonfire.UI.Social.HashtagsWidgetLive,
      ],
   ]
   # process: [
   #    navigation: [
   #       events: "Economic events",
   #       intents: "Intents",
   #       # material_passport: "material passport",
   #    ],
   #    sections: [
   #       events: Bonfire.UI.ValueFlows.EconomicEventsLive,
   #       intents: Bonfire.UI.ValueFlows.IntentsLive,
   #    ],
   #    widgets: [
   #      # Bonfire.UI.Social.SubscribeWidgetLive,
   #      # Bonfire.UI.ValueFlows.LocationWidgetLive,
   #      # Bonfire.UI.Social.HashtagsWidgetLive,
   #    ],
   # ]
