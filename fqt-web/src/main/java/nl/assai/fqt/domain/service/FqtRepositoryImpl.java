package nl.assai.fqt.domain.service;

import nl.assai.fqt.domain.ibatis.dao.fqt.FqtDao;
import nl.assai.fqt.domain.model.fqt.*;
import nl.assai.fqt.web.spring.JournalingUserFilter;

import java.util.ArrayList;
import java.util.List;

public class FqtRepositoryImpl implements FqtRepository {
    private FqtDao fqtDao;

    public void setFqtDao(FqtDao fqtDao) {
        this.fqtDao = fqtDao;
    }

    public List<VSCD> findAllVSCDs() {
        return  fqtDao.findAllVSCDs();
    }

    public List<VSCD> findAllSearchVSCDs(String search) {
        return  fqtDao.findAllSearchVSCDs(search);
    }

    public void insertVSCD(VSCD vscd) {
        identifyUser();
        fqtDao.insertVSCD(vscd);
    }

    public void updateVSCD(VSCD vscd) {
        identifyUser();
        fqtDao.updateVSCD(vscd);
    }

    public void deleteVSCD(VSCD vscd) {
        identifyUser();
        fqtDao.deleteVSCD(vscd);
    }


    public List<Contact> findAllContacts() {
        return  fqtDao.findAllContacts();
    }

    public List<Contact> findAllVSCDContacts(VSCD vscd) {
        return  fqtDao.findAllVSCDContacts(vscd);
    }

    public void insertContact(Contact contact) {
        identifyUser();
        fqtDao.insertContact(contact);
    }

    public void updateContact(Contact contact) {
        identifyUser();
        fqtDao.updateContact(contact);
    }

    public void deleteContact(Contact contact) {
        identifyUser();
        fqtDao.deleteContact(contact);
    }




    public void insertAction(Action action) {
        identifyUser();
        fqtDao.insertAction(action);
    }

    public List<Connection> findAllConnections() {
        return  fqtDao.findAllConnections();
    }

    public List<Connection> findConnectionsForQueryAndUser(Query query, User user) {
        return fqtDao.findConnectionsForQueryAndUser(query, user);
    }

    public Connection getConnectionByName(String name) {
        return fqtDao.getConnectionByName(name);
    }

    public void insertConnection(Connection connection) {
        identifyUser();
        fqtDao.insertConnection(connection);
    }

    public void updateConnection(Connection connection) {
        identifyUser();
        fqtDao.updateConnection(connection);
    }

    public void deleteConnection(Connection connection) {
        identifyUser();
        fqtDao.deleteConnection(connection);
    }

    public void insertLogin(Login login) {
        identifyUser();
        fqtDao.insertLogin(login);
    }

    public void insertMenu(Menu menu) {
        identifyUser();
        fqtDao.insertMenu(menu);
    }

    public List<Permission> findAllPermissions() {
        return fqtDao.findAllPermissions();
    }

    public List<Permission> findAllSearchPermissions(String search) {
        return fqtDao.findAllSearchPermissions(search);
    }

    public List<Permission> findPermissionsByRole(Role role) {
        return fqtDao.findPermissionsByRole(role);
    }

    public List<Permission> findPermissionsByUser(User user) {
        return fqtDao.findPermissionsByUser(user);
    }

    public Permission getPermissionByName(String name) {
        return fqtDao.getPermissionByName(name);
    }

    public void insertPermission(Permission permission) {
        identifyUser();
        fqtDao.insertPermission(permission);
    }

    public void updatePermission(Permission permission) {
        identifyUser();
        fqtDao.updatePermission(permission);
    }

    public void deletePermission(Permission permission) {
        identifyUser();
        fqtDao.deletePermission(permission);
    }

    public List<ReportConnection> findAllReportConnections() {
        return fqtDao.findAllReportConnections();
    }

    public ReportConnection getReportConnectionByName(String name) {
        return fqtDao.getReportConnectionByName(name);
    }

    public void insertReportConnection(ReportConnection reportconnection) {
        identifyUser();
        fqtDao.insertReportConnection(reportconnection);
    }

    public void updateReportConnection(ReportConnection reportconnection) {
        identifyUser();
        fqtDao.updateReportConnection(reportconnection);
    }

    public void deleteReportConnection(ReportConnection reportconnection) {
        identifyUser();
        fqtDao.deleteReportConnection(reportconnection);
    }

    public List<UrlLink> findUrlLinks(User user, String menu) {
        return fqtDao.findUrlLinks(user, menu);
    }

    public List<Query> findAllQueries() {
        return fqtDao.findAllQueries();
    }

    public List<Query> findAllSearchQueries(String search) {
        return fqtDao.findAllSearchQueries(search);
    }

    public List<Query> findAllQueriesOrderByRecent() {
        return fqtDao.findAllQueriesOrderByRecent();
    }

    public Query getQueryByName(String name) {
        return fqtDao.getQueryByName(name);
    }

    public void insertQuery(Query query) {
        identifyUser();
        fqtDao.insertQuery(query);
    }

    public void updateQuery(Query query) {
        identifyUser();
        fqtDao.updateQuery(query);
    }

    public void deleteQuery(Query query) {
        identifyUser();
        fqtDao.deleteQuery(query);
    }

    public List<Query> findReports(User user, String reportName) {
        return fqtDao.findReports(user, reportName);
    }

    public List<Link> getRolePermissionLinks(Role role) {
        return fqtDao.getRolePermissionLinks(role);
    }

    public void insertRolePermission(Link link) {
        identifyUser();
        fqtDao.insertRolePermission(link);
    }

    public void deleteRolePermissionLinks(Role role) {
        identifyUser();
        fqtDao.deleteRolePermissionLinks(role);
    }

    public List<Role> findAllRoles() {
        return fqtDao.findAllRoles();
    }

    public List<Role> findAllSearchRoles(String search) {
        return fqtDao.findAllSearchRoles(search);
    }

    public List<Role> findAllRolesOfType(String roleName) {
        return fqtDao.findAllRolesOfType(roleName);
    }

    public List<Role> findRolesByUser(Long userId) {
        return fqtDao.findRolesByUser(userId);
    }

    public void insertRole(Role role) {
        identifyUser();
        fqtDao.insertRole(role);
    }

    public void updateRole(Role role) {
        identifyUser();
        fqtDao.updateRole(role);

        // Refresh role-permisions too
        fqtDao.deleteRolePermissionLinks(role);
        for (Permission permission : role.getPermissions()) {
            Link link = new Link();
            link.setFromId(role.getId());
            link.setToId(permission.getId());
            fqtDao.insertRolePermission(link);
        }
    }

    public void deleteRole(Role role) {
        identifyUser();
        
        // Delete role-permisions first
        fqtDao.deleteRolePermissionLinks(role);
        fqtDao.deleteRole(role);
    }

    public List<User> findAllUsers() {
        return fqtDao.findAllUsers();
    }

    public List<User> findAllSearchUsers(String search) {
        return fqtDao.findAllSearchUsers(search);
    }

    public User getUserByName(String name) {
        return fqtDao.getUserByName(name);
    }

    public User getUserByIdmId(String idmId) {
        return fqtDao.getUserByIdmId(idmId);
    }

    public List<Link> getUserRoleLinks(User user) {
        return fqtDao.getUserRoleLinks(user);
    }

    public void insertUserRole(Link link) {
        identifyUser();
        fqtDao.insertUserRole(link);
    }

    public void deleteUserRoleLinks(User user) {
        identifyUser();
        fqtDao.deleteUserRoleLinks(user);
    }

    public List<User> findUsersByRole(Role role) {
        return fqtDao.findUsersByRole(role);
    }

    public Integer checkCurrentPassword(User user) {
        return fqtDao.checkCurrentPassword(user);
    }

    public Integer checkPasswordChanged(User user) {
        return fqtDao.checkPasswordChanged(user);
    }

    public void changePassword(User user) {
        identifyUser();
        fqtDao.changePassword(user);
    }

    public String hashPassword(String pwd) {
        return fqtDao.hashPassword(pwd);
    }

    public Long getUserIdByUserNamePassword(User user){
        return fqtDao.getUserIdByUserNamePassword(user);
    };

    public List<UserMenu> findUserMenus(Long userId) {
        return fqtDao.findUserMenus(userId);
    }

    public void insertUser(User user) {
        identifyUser();
        fqtDao.insertUser(user);
    }

    public void updateUser(User user) {
        identifyUser();
        fqtDao.updateUser(user);
    }

    public void deleteUser(User user) {
        identifyUser();
        fqtDao.deleteUser(user);
    }

    public void updateUserRoles(User user) {
        identifyUser();
        // Refresh user-roles
        fqtDao.deleteUserRoleLinks(user);
        for (Role role : user.getRoles()) {
            Link link = new Link();
            link.setFromId(user.getId());
            link.setToId(role.getId());
            fqtDao.insertUserRole(link);
        }
    }

    public List<MenuNode> findAllMenuNodes() {
        return fqtDao.findAllMenuNodes();
    }
    public List<MenuNode> findAllMenuNodesOrderByDisplay() {
        return fqtDao.findAllMenuNodesOrderByDisplay();
    }
    public List<MenuNode> findPossibleParentMenuNodes(MenuNode currentNode) {
        List<MenuNode> possibleNodes = findAllMenuNodes();
        // filter out descendent nodes
        if (currentNode != null) {
            List<MenuNode> descendents = new ArrayList<MenuNode>();
            descendents.add(currentNode);
            findDescendents(currentNode, possibleNodes, descendents);
            possibleNodes.removeAll(descendents);
        }
        return possibleNodes;
    }
    private void findDescendents(MenuNode currentNode, List<MenuNode> allNodes, List<MenuNode> descendents) {
        for (MenuNode node : allNodes) {
            if (node.getParentId() != null && node.getParentId().equals(currentNode.getId())) {
                descendents.add(node);
                findDescendents(node, allNodes, descendents);
            }
        }
    }
    public void insertMenuNode(MenuNode menuNode) {
        identifyUser();
        fqtDao.insertMenuNode(menuNode);
    }
    public void updateMenuNode(MenuNode menuNode) {
        identifyUser();
        fqtDao.updateMenuNode(menuNode);
    }
    public void deleteMenuNode(MenuNode menuNode) {
        identifyUser();
        fqtDao.deleteMenuNode(menuNode);
    }

    private void identifyUser() {
        fqtDao.setJournalingUser(JournalingUserFilter.getJournalingUserName());
    }
}
