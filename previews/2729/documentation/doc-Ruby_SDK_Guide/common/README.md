This directory is used to store files that are included in more than one guide or assembly.

In order to reference a file from common, you must tell the relevant guide, both locally and in Pantheon, where to look for that file.

To include a file from the common directory in a guide:

1. Create the file you want to share and place it in the `common` directory.
2. In the assembly (for example, `master.adoc`) in which you want to include the file, add an include that references `common`:

    //include::common/blah.adoc

3. In the directory for all guides in which the file appears, create a symbolic link to the `common` directory:

    ln -s ../common .

4. Edit the Pantheon configuration entry for each guide in which the file appears. Under the *Additional Content Directories* field, enter `common`, and save the configuration.


