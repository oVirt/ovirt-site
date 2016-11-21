---
title: AddTabs
authors: derez, ecohen, gchaplik
wiki_title: Documentation/webadmin/AddTabs
wiki_revision_count: 7
wiki_last_updated: 2012-02-07
---

<!-- TODO: Content review -->

# Add Tabs

## Webadmin - Tabs

### Summary

A short explanation on how to add tabs in the oVirt webadmin website.

### Owner

*   Name: Gilad Chaplik (gchaplik)
*   Email: <gchaplik@redhat.com>

### Detailed Description

The webadmin is based on the MVP framework, where:

*   Models: are the uicommonweb project.
*   Views: webadmin project (\*View.java).
*   Presenters: webadmin project (\*Presenter.java).

Every tab consists of this trio.

#### Tab Model

The base model of the project is the CommonModel (resides in uicommonweb project). the InitItems() method initializes all the models that are presented as main tabs. As you can see you ought to create a \*ListModel class that is the model of the tab.

*   ListModel class inherits from ListWithDetailsModel and implements ISupportSystemTreeContext.

ListWithDetailsModel is in charge of adding sub tabs to the main tab, and ISupportSystemTreeContext add the tree navigation related functionality. In ListWithDetailsModel, SyncSearch is the method that is invoked for fetching the business entities from the server and setting the items accordingly (SetItems method).

###### Create a dialog

First add a uicommand associated with the dialog (UICommand). In the uicommand c'tor, set the "target" parameter as the class instance which contains the ExecuteCommand() method that will be triggered upon executing it (i.e. invoking its "Execute" method).

E.g:

             setEditCommand(new UICommand("Edit", this));

it will be invoked in:

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

For the action availability, create a method for it that will be called in the override method of OnSelectedItemChanged:

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

(This means that the "edit" command will be enabled only when there is only one item selected)

You can get the selected item by calling getSelectedItem().

To create a dialog, you need to create a model for it, named \*Model (e.g. HostModel). When the Edit command is executed, instantiate the relevant model and set the Window property accordingly. In the following example, we are instantiating the DataCenterModel:

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

The setWindow method will "open" the dialog (model wise) - an event will be raised for the presenter to open a new window in the view.

Add to the model UICommands for closing the dialog and/or submitting something to the server. In the following example, we add a UICommand for saving the object ("OnSave") and another one for canceling the operation ("Cancel"):

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

As I mentioned earlier, the command will be triggered in the ExecuteCommand method override of the class that passed as a parameter to the UICommand constructor:

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

In order to "close" the popup (again - model wise) you need to set the window property to null:

             void cancel()
             {
                     setWindow(null);
             }

in onSave method get the window model by getWindow():

             public void onSave()
             {
                     DataCenterModel model = (DataCenterModel)getWindow();
                     
                     if (!model.Validate())
                     {
                             return;
                     }

Within the dialog model class (e.g. HostModel), use EntityModel and ListModel (represent a list/dropdown) (there is a binding mechanism for them); the value property is get/setEntiy and get/setItems respectively:

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

These entities contain event for changing (getEntityChangedEvent(), getItemsChangedEvent()), other properties like visibility (set/getIsAvailable()), enabled (set/getIsChangable()), Validation (ValidateEntity(new IValidation[] { new NotEmptyValidation(), tempVar, tempVar2 });, getIsValid()) and more.

#### Tab Presenter & View

##### Create a Tab

###### Tab Presenter

Create a MainTab\*Presenter.java class as your tab presenter (e.g. MainTabHostPresenter.java)

             public class MainTabVolumePresenter extends AbstractMainTabWithDetailsPresenter`<GlusterVolume, VolumeListModel, MainTabVolumePresenter.ViewDef, MainTabVolumePresenter.ProxyDef>` {

in the generics supply your entity class (GlusterVolume, VDS), model class (VolumeListModel, HostListModel), and the intefaces that the GWTP enforce (ViewDef & ProxyDef)

             @ProxyCodeSplit
             @NameToken(ApplicationPlaces.volumeMainTabPlace)
             public interface ProxyDef extends TabContentProxyPlace`<MainTabVolumePresenter>` {
             }
             public interface ViewDef extends AbstractMainTabWithDetailsPresenter.ViewDef`<GlusterVolume>` {
             }

Within that class supply a static method that insert it to the TabContainer:

             @TabInfo(container = MainTabPanelPresenter.class)
             static TabData getTabData(ClientGinjector ginjector) {
                     return new ModelBoundTabData(ginjector.getApplicationConstants().volumeMainTabLabel() //the label of the tab
                             , 4, //the order of the tab in the container
                             ginjector.getMainTabVolumeModelProvider()); // the data provider of the tab
             }

Implement other method of the presenter (also create an event class for the tab, e.g. VolumeSelectionChangeEvent, pretty straight forward):

             @Override
             protected void fireTableSelectionChangeEvent() {
                     VolumeSelectionChangeEvent.fire(this, getSelectedItems()); //create a class *SelectionChangeEvent.java)
             }

             @Override
             protected PlaceRequest getMainTabRequest() {
                     return new PlaceRequest(ApplicationPlaces.volumeMainTabPlace);
             }
             @Override
             protected PlaceRequest getDefaultSubTabRequest() {
                     return new PlaceRequest(ApplicationPlaces.volumeGeneralSubTabPlace); //the sub tab default tab
             }

###### Default Tab

In SystemModule.java set the default place to be the main tab that you want to be displayed on startup (e.g. hostMainTabPlace)

              bindConfiguration() {
                       bindConstant().annotatedWith(DefaultLoginSectionPlace.class).to(ApplicationPlaces.loginPlace);
                       bindConstant().annotatedWith(DefaultMainSectionPlace.class).to(ApplicationPlaces.hostMainTabPlace);
                       bind(ApplicationConstants.class).in(Singleton.class);

And another enum item (enum ApplicationPlaces) for your new place link the enum item to the tab presenter:

              @ProxyCodeSplit
              @NameToken(ApplicationPlaces.hostMainTabPlace)
              public interface ProxyDef extends TabContentProxyPlace`<MainTabHostPresenter>` {
              }

###### View

###### gin

Add to gin/ManagedComponent.java the proxy to get the tab presenter, and also the proxy to get the model linkage (ModelProvider.java):

              AsyncProvider`<MainTabVolumePresenter>` getMainTabVolumePresenter();
              
              MainModelProvider`<GlusterVolume, VolumeListModel>` getMainTabVolumeModelProvider();

Bind the view and model:

             bindPresenter(MainTabVolumePresenter.class,
                     MainTabVolumePresenter.ViewDef.class,
                     MainTabVolumeView.class,
                     MainTabVolumePresenter.ProxyDef.class);

Create a new Module for your new tab (\*Module.java, e.g. HostModule.java): implement the protected methods getModelPopup(1) & getConfirmModelPopup(1), in order to open other sets of popup when invoking the Window/ConfirmWindow properties:

             @Provides
             @Singleton
             public MainModelProvider`<GlusterVolume, VolumeListModel>` getVolumeListProvider(ClientGinjector ginjector) {
                     return new MainTabModelProvider`<GlusterVolume, VolumeListModel>`(ginjector, VolumeListModel.class) {
                     @Override
                     protected AbstractModelBoundPopupPresenterWidget`<? extends Model, ?>` getModelPopup(UICommand lastExecutedCommand) {
                             return super.getModelPopup(lastExecutedCommand);
                     }

                     @Override
                     protected AbstractModelBoundPopupPresenterWidget`<? extends ConfirmationModel, ?>` getConfirmModelPopup(UICommand lastExecutedCommand) {
                             return super.getConfirmModelPopup(lastExecutedCommand);
                     }
             };

You can get the Model class by calling getModel().
