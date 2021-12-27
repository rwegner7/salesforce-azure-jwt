## Fixed Component Solution

To create a fixed component, modifications were made to the Dynamic Manager, Dynamic Templates and Work Area components in the MAX Framework. Fixed Components are displayed across all workflows until they are destroyed by a custom Lightning Message.

In *Dynamic Templates*, a new template type called 'fixedExtensions' was added. Any components that need to be fixed or permanently displayed can be added to this template type, the same way that right rails and workflows currently are.

In *Work Area*, we created a new section in the right rail, above the rightRails dynamic manager.
```
 <!-- RIGHT COL -->
<lightning-layout-item size="3" class="csff-column slds-p-top_x-small">
    <c-csff-dynamic-manager
            active-action={activeAction}
            template-type="fixedExtensions"
    ></c-csff-dynamic-manager>
    <c-csff-dynamic-manager
            active-action={activeAction}
            template-type="rightRails"
    ></c-csff-dynamic-manager>
</lightning-layout-item>
```

**Work Area UI Example:**

Left Rail | Workflow | Right Rail
| :--- | :---: | ---:
Nav  | Workflow | Fixed Component
 . | . | Right Rail

In *Dynamic Manager*, modifications were made to handle 'fixedExtensions' templates.
- The fixed component is created when the workflow is initiated. For example, if the 'claim_summary_workflow' action has a fixed component, it will be created and displayed when the claim_summary_workflow component is also created.
- More than one fixed component can be displayed in the right rail. The order of the components depends on the order in which they were initiated (as they are stored in an array).
- The components will persist across workflows, and always be displayed at the top of the right rail.
- When the component needs to be destroyed, a custom LMS message (CsfsDestroyRequest) is sent to the Dynamic Manager and handled. 
	- The LMS message accepts a single parameter, *key* which represents the workflow action (e.g. 'claim_summary_workflow'). 
	- Dynamic Manager deletes that component from the screen when the message is received.
	- Only one component can be deleted at a time.
	- Once a component is deleted, it cannot be recreated if the workflow is clicked on again. TODO??
	- The LMS message can be sent from any component on the UI.


METADATA LIST
### Message Channel
CsfsDestroyRequest

### LWC
csffDynamicManager
csffWorkArea
csffDynamicTemplates
