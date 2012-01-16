---
title: AddTabs
authors: derez, ecohen, gchaplik
wiki_title: Documentation/webadmin/AddTabs
wiki_revision_count: 7
wiki_last_updated: 2012-02-07
---

# Add Tabs

## Webadmin - Tabs

### Summary

A short explanation on how to add tabs in the oVirt webadmin website.

### Owner

*   Name: [ Gilad Chaplik](User:gchaplik)
*   Email: <gchaplik@redhat.com>

### Detailed Description

The webadmin is based on the MVP framework, where:

*   Models: are the uicommonweb project.
*   Views: webadmin project (\*View.java).
*   Presenters: webadmin project (\*Presenter.java).

Every tab consist on these trio.

#### Tab Model

The base model of the project is the CommonModel (resides in uicommonweb project). the InitItems() method initialize all the models that are presented as main tabs, as you can see you ought to create a \*ListModel class that is the model of the tab.

*   ListModel class inherits from ListWithDetailsModel and implements ISupportSystemTreeContext.

ListWithDetailsModel is incharge of adding sub tabs to the main tab, and ISupportSystemTreeContext add the tree navigation functionality. in ListWithDetailsModel, SyncSearch is the method that is invoked for fetching the items from the server, and setting the items (SetItems method).

###### Create a dialog

First add a uicommad associated with it (UICommand), it the command set the method class that will be triggered upon invoking it (setEditCommand(new UICommand("Edit", this));), it will be invoked in

             @Override
             public void ExecuteCommand(UICommand command)
             {
                     super.ExecuteCommand(command);
                     
                     ....
                     else if (command == getEditCommand())
                     {
                             Edit();
                     }
                     ...
             }

for the action availabitlity create a method for it that will be called in the override method of OnSelectedItemChanged:

             @Override
             protected void OnSelectedItemChanged()
             {
                     super.OnSelectedItemChanged();
                     UpdateActionAvailability();
             }

and then you can disable the action according the status of the model:

             private void UpdateActionAvailability()
             {
                     getEditCommand().setIsExecutionAllowed(getSelectedItem() != null && items.size() == 1);
                     ...

(this means that the edit command will be enabled only when there is only one item selected) you can get the seleceted item by calling getSelectedItem().

To create the dialog you need a model for it \*Model (i.e. HostModel). when Edit button is invoked Create the model and set the Window property.

             public void Edit()
             {
                     storage_pool dataCenter = (storage_pool)getSelectedItem();
                     
                     if (getWindow() != null)
                     {
                             return;
                     }
                     DataCenterModel model = new DataCenterModel();
                     setWindow(model);
                     ...

the setWindow will open the dialog (model wise)

Add to the model UICommands for closing it or submitting something to the server

                     ....
                     UICommand onSaveCommand = new UICommand("OnSave", this);
                     onSaveCommand.setTitle("OK");
                     onSaveCommand.setIsDefault(true);
                     model.getCommands().add(onSaveCommand);
                     UICommand cancelCommand = new UICommand("Cancel", this);
                     cancelCommand.setTitle("Cancel");
                     cancelCommand.setIsCancel(true);
                     model.getCommands().add(cancelCommand);
             }

As I mentioned earlier the command will be triggered in the ExecuteCommand method override of the class that passed as a parameter to the UICommand constructor

             @Override
             public void ExecuteCommand(UICommand command)
             {
                     super.ExecuteCommand(command);
                     
                     ....
                     else if (command.getName == "OnSave")
                     {
                             onSave();
                     }
                             else if (command.getName == "cancel")
                     {
                             cancel();
                     }
                     ...
             }

In order to close the popup (again model wise) you need to set the window property with null

             void cancel()
             {
                     setWindow(null);
             }

in onSave method get the window model by getWindow().

             public void onSave()
             {
                     DataCenterModel model = (DataCenterModel)getWindow();
                     
                     if (!model.Validate())
                     {
                             return;
                     }

inside the dialog class (i.e HostModel) use EntityModel and ListModel (represents a list/dropdown) as the field of the dialog (the is a binding mechanism for them), the value property is get/setEntiy and get/setItems respectively.

             private EntityModel privateName;
             public EntityModel getName()
             {
                     return privateName;
             }
             
             private void setName(EntityModel value)
             {
                     privateName = value;
             }
             
             ..
             public constructor() {
             ..
                     setName(new EntityModel());
                     getName().setEntity("value as string");
             ...
             }

these entities contain event for changing (getEntityChangedEvent(), getItemsChangedEvent()), other properties like visibility (set/getIsAvailable()), enabled (set/getIsChangable()), Validation (ValidateEntity(new IValidation[] { new NotEmptyValidation(), tempVar, tempVar2 });, .getIsValid()) and more.

#### Tab Presenter & View
